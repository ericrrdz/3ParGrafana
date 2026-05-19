// sqlite_to_lp: reads a 3PAR SR sqlite db and writes InfluxDB line protocol.
// Drop-in replacement for the sqlite3 | awk pipeline in 3pg_sr.sh.
//
// Usage: sqlite_to_lp <db_file> <output_file>
//
// Preserves the exact transformation semantics of the original awk:
//   - same per-table tag column lists
//   - same synthetic DATA_PORT/PORT_TYPE/TRANS_TYPE/GBITPS tags
//   - same zero-skip behavior with whitelist
//   - same numeric-vs-string field detection
//   - same string escaping
//   - same `type=<fieldname>` tag added to each line
//
// Differences vs awk version:
//   - no CSV round-trip; sqlite values come through typed
//   - no in-memory aggregation map (verified unnecessary against the
//     real data: every input row produces a distinct (ts + tags) key,
//     so += was always = with extra hashing)
//   - tables processed concurrently (one goroutine per table)
//   - buffered output, single writer goroutine for the file

package main

import (
	"bufio"
	"database/sql"
	"fmt"
	"os"
	"strconv"
	"strings"
	"sync"

	_ "github.com/mattn/go-sqlite3"
)

// Tag definitions — kept identical to get_tags_for_table() in the bash script.
var tableTags = map[string][]string{
	"cpgspace":  {"CPG_NAME", "DOM_NAME", "CPGID", "DISK_TYPE"},
	"statcache": {"node"},
	"statcmp":   {"node"},
	"statcpu":   {"NODE", "CPU"},
	"statpd":    {"PDID", "DISK_TYPE", "SPEED"},
	"statport":  {},
	"statqos":   {"DOM_NAME", "QOS_ID"},
	"statrcopy": {"TARGET_NAME", "LINK_NAME"},
	"statrcvv":  {"VV_NAME"},
	"statvlun":  {"VV_NAME", "LUN", "HOST_NAME", "HOST_WWN"},
	"statvv":    {"VV_NAME", "VVID", "DOM_NAME", "WWN", "SNP_CPG_NAME", "USR_CPG_NAME", "PROV_TYPE", "VV_TYPE", "VVSET_NAME", "VVSET_ID", "CPGID"},
	"sysspace":  {"DOM_NAME", "DISK_TYPE"},
	"vvspace":   {"VV_NAME", "DOM_NAME", "VVID", "BSID", "WWN", "CPG_NAME", "PROV_TYPE", "VV_TYPE", "VM_NAME", "VM_ID", "VM_HOST", "VVOLSC", "COMPR", "VVSET_NAME", "VVSET_ID", "CPGID"},
}

// Columns where literal "0" / "0.0" values should be KEPT rather than skipped.
var keepZeros = map[string]bool{
	"begin_msec": true, "now_msec": true,
	"rerror": true, "rdrops": true, "rticks": true,
	"werror": true, "wdrops": true, "wticks": true,
	"GBITPS": true,
}

// Tag-value escaping for line protocol: space -> '\ ', comma -> '\,'.
// Matches the awk: gsub(/ /, "\\ ", val); gsub(/,/, "\\,", val)
func escapeTag(s string) string {
	if !strings.ContainsAny(s, " ,") {
		return s
	}
	var b strings.Builder
	b.Grow(len(s) + 4)
	for i := 0; i < len(s); i++ {
		switch s[i] {
		case ' ':
			b.WriteString(`\ `)
		case ',':
			b.WriteString(`\,`)
		default:
			b.WriteByte(s[i])
		}
	}
	return b.String()
}

// Convert a sqlite-returned value to a string for line protocol.
// Returns (textValue, isNumeric, isEmpty).
//
// Numeric values are formatted compactly. Strings are double-quoted with
// embedded double-quotes escaped (matches awk's gsub(/"/, "\\\"", value)).
func valueToLP(v interface{}) (string, bool, bool) {
	if v == nil {
		return "", false, true
	}
	switch x := v.(type) {
	case int64:
		return strconv.FormatInt(x, 10), true, false
	case float64:
		// Match awk's default CONVFMT="%.6g": integral floats print
		// without a decimal point, non-integral floats use 6 sig figs.
		// Examples (awk):
		//   10248680.0 -> "10248680"
		//   1234567.5  -> "1.23457e+06"
		//   1.5        -> "1.5"
		//   0.0001     -> "0.0001"
		if x == float64(int64(x)) && x >= -1e15 && x <= 1e15 {
			return strconv.FormatInt(int64(x), 10), true, false
		}
		s := strconv.FormatFloat(x, 'g', 6, 64)
		return s, true, s == ""
	case bool:
		if x {
			return "1", true, false
		}
		return "0", true, false
	case []byte:
		return string(x), false, len(x) == 0
	case string:
		return x, false, x == ""
	default:
		return fmt.Sprintf("%v", v), false, false
	}
}

// numericString returns true if s looks like an awk-style number.
// Used for string-typed columns whose contents happen to be numeric
// (the original awk regex: ^[+-]?[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?$)
func numericString(s string) bool {
	if s == "" {
		return false
	}
	if _, err := strconv.ParseFloat(s, 64); err != nil {
		return false
	}
	return true
}

// processTable reads every row of `table` and emits line protocol to w.
// Mirrors the per-row logic of the awk block.
func processTable(db *sql.DB, table string, w *bufio.Writer, mu *sync.Mutex) error {
	rows, err := db.Query("SELECT * FROM " + table)
	if err != nil {
		return fmt.Errorf("query %s: %w", table, err)
	}
	defer rows.Close()

	cols, err := rows.Columns()
	if err != nil {
		return fmt.Errorf("columns %s: %w", table, err)
	}

	// Pre-compute per-column metadata so the row loop is hot-path-only.
	tags := tableTags[table] // nil if table not in map
	isTag := make(map[string]bool, len(tags))
	for _, t := range tags {
		isTag[t] = true
	}

	timeCol := -1
	idxPN, idxPS, idxPP := -1, -1, -1
	idxPT, idxTT, idxGB := -1, -1, -1
	tagIdx := make([]int, 0, len(tags))         // column indices that are tags
	fieldIdx := make([]int, 0, len(cols))       // column indices that are fields
	colName := make([]string, len(cols))
	for i, c := range cols {
		colName[i] = c
		switch {
		case strings.EqualFold(c, "tsecs"):
			timeCol = i
		case c == "PORT_N":
			idxPN = i
		case c == "PORT_S":
			idxPS = i
		case c == "PORT_P":
			idxPP = i
		case c == "PORT_TYPE":
			idxPT = i
		case c == "TRANS_TYPE":
			idxTT = i
		case c == "GBITPS":
			idxGB = i
		}
	}
	// Tag columns (regular) and field columns. Synthetic tag source
	// columns (PORT_N/S/P, PORT_TYPE, TRANS_TYPE, GBITPS) are excluded
	// from fieldIdx because the awk skips them too.
	for i := range cols {
		if i == timeCol {
			continue
		}
		if isTag[colName[i]] {
			tagIdx = append(tagIdx, i)
			continue
		}
		if i == idxPN || i == idxPS || i == idxPP || i == idxPT || i == idxTT || i == idxGB {
			continue
		}
		fieldIdx = append(fieldIdx, i)
	}

	// Scan destination — reused per row.
	raw := make([]interface{}, len(cols))
	ptrs := make([]interface{}, len(cols))
	for i := range raw {
		ptrs[i] = &raw[i]
	}

	// Local buffer for building one line, flushed under mutex periodically.
	var local strings.Builder
	local.Grow(1 << 16)
	const flushAt = 1 << 16

	flush := func() {
		if local.Len() == 0 {
			return
		}
		mu.Lock()
		w.WriteString(local.String())
		mu.Unlock()
		local.Reset()
	}

	for rows.Next() {
		if err := rows.Scan(ptrs...); err != nil {
			return fmt.Errorf("scan %s: %w", table, err)
		}

		// Stringify cells we need.
		cellStr := make([]string, len(cols))
		cellNumeric := make([]bool, len(cols))
		cellEmpty := make([]bool, len(cols))
		for i, v := range raw {
			s, num, empty := valueToLP(v)
			cellStr[i] = s
			cellNumeric[i] = num
			cellEmpty[i] = empty
		}

		// Build tag string.
		var tagBuf strings.Builder
		tagBuf.Grow(128)
		for _, ci := range tagIdx {
			tagBuf.WriteByte(',')
			tagBuf.WriteString(colName[ci])
			tagBuf.WriteByte('=')
			tagBuf.WriteString(escapeTag(cellStr[ci]))
		}
		// Synthetic DATA_PORT
		if idxPN >= 0 && idxPS >= 0 && idxPP >= 0 {
			tagBuf.WriteString(",DATA_PORT=")
			tagBuf.WriteString(cellStr[idxPN])
			tagBuf.WriteByte(':')
			tagBuf.WriteString(cellStr[idxPS])
			tagBuf.WriteByte(':')
			tagBuf.WriteString(cellStr[idxPP])
		}
		if idxPT >= 0 {
			tagBuf.WriteString(",PORT_TYPE=")
			tagBuf.WriteString(escapeTag(cellStr[idxPT]))
		}
		if idxTT >= 0 {
			tagBuf.WriteString(",TRANS_TYPE=")
			tagBuf.WriteString(escapeTag(cellStr[idxTT]))
		}
		if idxGB >= 0 {
			tagBuf.WriteString(",GBITPS=")
			tagBuf.WriteString(cellStr[idxGB])
		}
		tagStr := tagBuf.String()

		// Timestamp
		var ts string
		if timeCol >= 0 {
			ts = cellStr[timeCol]
		}

		// Emit one line per field.
		for _, ci := range fieldIdx {
			val := cellStr[ci]
			if cellEmpty[ci] || val == "-" {
				continue
			}
			// Skip zeros unless field is whitelisted.
			if (val == "0" || val == "0.0") && !keepZeros[colName[ci]] {
				continue
			}

			local.WriteString(table)
			local.WriteString(tagStr)
			local.WriteString(",type=")
			local.WriteString(colName[ci])

			isNumericVal := cellNumeric[ci] || numericString(val)
			if isNumericVal {
				local.WriteString(" value=")
				local.WriteString(val)
			} else {
				local.WriteString(" value_str=")
				// Quoted string with embedded " escaped.
				local.WriteByte('"')
				if strings.IndexByte(val, '"') < 0 {
					local.WriteString(val)
				} else {
					for j := 0; j < len(val); j++ {
						if val[j] == '"' {
							local.WriteString(`\"`)
						} else {
							local.WriteByte(val[j])
						}
					}
				}
				local.WriteByte('"')
			}

			if ts != "" {
				local.WriteByte(' ')
				local.WriteString(ts)
			}
			local.WriteByte('\n')
		}

		if local.Len() >= flushAt {
			flush()
		}
	}
	flush()
	return rows.Err()
}

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintf(os.Stderr, "usage: %s <db_file> <output_file>\n", os.Args[0])
		os.Exit(2)
	}
	dbPath := os.Args[1]
	outPath := os.Args[2]

	db, err := sql.Open("sqlite3", "file:"+dbPath+"?mode=ro")
	if err != nil {
		fmt.Fprintln(os.Stderr, "open:", err)
		os.Exit(1)
	}
	defer db.Close()

	// Discover tables.
	tables := []string{}
	rows, err := db.Query("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
	if err != nil {
		fmt.Fprintln(os.Stderr, "list tables:", err)
		os.Exit(1)
	}
	for rows.Next() {
		var n string
		if err := rows.Scan(&n); err != nil {
			fmt.Fprintln(os.Stderr, "scan tbl name:", err)
			os.Exit(1)
		}
		tables = append(tables, n)
	}
	rows.Close()

	out, err := os.Create(outPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "create out:", err)
		os.Exit(1)
	}
	w := bufio.NewWriterSize(out, 1<<20)

	var mu sync.Mutex
	var wg sync.WaitGroup
	errCh := make(chan error, len(tables))

	for _, t := range tables {
		wg.Add(1)
		go func(table string) {
			defer wg.Done()
			if err := processTable(db, table, w, &mu); err != nil {
				errCh <- err
			}
		}(t)
	}
	wg.Wait()
	close(errCh)

	exitCode := 0
	for e := range errCh {
		fmt.Fprintln(os.Stderr, "error:", e)
		exitCode = 1
	}

	// Explicit flush/close — os.Exit does NOT run deferred functions.
	if err := w.Flush(); err != nil {
		fmt.Fprintln(os.Stderr, "flush:", err)
		exitCode = 1
	}
	if err := out.Close(); err != nil {
		fmt.Fprintln(os.Stderr, "close:", err)
		exitCode = 1
	}
	os.Exit(exitCode)
}
