#!/usr/bin/env bash
# Converts a Markdown file (headers, bold, code, links, lists, tables) into
# Confluence's HTML+ dialect - the format the Atlassian MCP connector's
# createConfluencePage/updateConfluencePage tools expect, NOT legacy XHTML
# storage format. Superseded md-to-storage.sh: that format's <colgroup>/
# class="confluenceTh" gets silently stripped by Confluence on save (proven
# by reading a published page back) - this one uses data-colwidth per cell
# and data-background on header cells, which round-trip correctly.
# Deliberately handles only the constructs this pack's own generated
# content actually uses - not a general-purpose Markdown parser.
set -euo pipefail

MODE=""
INPUT_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --md) MODE="md"; INPUT_FILE="$2"; shift 2 ;;
    --csv) MODE="csv"; INPUT_FILE="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$MODE" || -z "$INPUT_FILE" ]]; then
  echo "Usage: md-to-htmlplus.sh --md <file.md> | --csv <file.csv>" >&2
  exit 1
fi

HEADER_BG="#8993A5"

escape_xml() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Converts basic inline Markdown (bold, code, links) within one line.
inline_to_html() {
  local line="$1"
  line=$(echo "$line" | escape_xml)
  line=$(echo "$line" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')
  line=$(echo "$line" | sed -E 's/`([^`]+)`/<code>\1<\/code>/g')
  line=$(echo "$line" | sed -E 's/\[([^]]+)\]\(([^)]+)\)/<a href="\2">\1<\/a>/g')
  echo "$line"
}

parse_csv_line() {
  local line="$1"
  CSV_FIELDS=()
  local field="" in_quotes=0 i=0 len=${#line} char next_char
  while (( i < len )); do
    char="${line:i:1}"
    if [[ "$char" == '"' ]]; then
      next_char="${line:i+1:1}"
      if (( in_quotes )) && [[ "$next_char" == '"' ]]; then
        field+='"'
        ((i++))
      else
        (( in_quotes = 1 - in_quotes ))
      fi
    elif [[ "$char" == "," && $in_quotes -eq 0 ]]; then
      CSV_FIELDS+=("$field")
      field=""
    else
      field+="$char"
    fi
    ((i++))
  done
  CSV_FIELDS+=("$field")
}

# Renders a full table from ROWS (each element is one row's cells joined by
# the unit separator \x1f) - first row is the header, split into <thead>.
# Column widths: proportional to each column's longest cell, clamped so no
# single column exceeds a third of the table and none falls below a legible
# floor, then renormalized back to the target total - without the clamp+
# renormalize, one long-text column (e.g. Rationale) dominates while short
# columns (Status, Date) collapse to the floor and the real total silently
# balloons past what was intended (found and fixed against a live page).
render_table() {
  local -a rows=("$@")
  (( ${#rows[@]} == 0 )) && return
  # Every row was built with a trailing \x1f. sentinel (see callers) so that
  # `read -a`'s here-string field-splitting - which silently drops a
  # genuinely trailing empty field - never eats a legitimately blank last
  # cell. num_cols is field count minus that sentinel.
  local -a first_cells
  IFS=$'\x1f' read -r -a first_cells <<< "${rows[0]}"
  local num_cols=$(( ${#first_cells[@]} - 1 ))
  # A header row of all-blank cells (source "| | |") means this is an
  # intentionally headerless property table, not a table with an empty
  # label - skip the header band entirely rather than rendering an empty
  # blue strip above the real first data row.
  local has_header=0 hi
  for ((hi = 0; hi < num_cols; hi++)); do
    if [[ -n "${first_cells[hi]}" ]]; then
      has_header=1
      break
    fi
  done
  local -a maxlen
  local i
  for ((i = 0; i < num_cols; i++)); do maxlen[i]=1; done
  local row
  local -a cells
  for row in "${rows[@]}"; do
    IFS=$'\x1f' read -r -a cells <<< "$row"
    for ((i = 0; i < num_cols; i++)); do
      local len=${#cells[i]}
      (( len > maxlen[i] )) && maxlen[i]=$len
    done
  done
  local total=0
  for ((i = 0; i < num_cols; i++)); do (( total += maxlen[i] )); done
  (( total == 0 )) && total=1
  local target_width=$(( num_cols * 180 ))
  (( target_width < 1500 )) && target_width=1500
  (( target_width > 2400 )) && target_width=2400
  local min_width=110
  local max_width=$(( target_width / 3 ))
  (( max_width < min_width )) && max_width=$min_width

  local -a widths
  local wsum=0
  for ((i = 0; i < num_cols; i++)); do
    local w=$(( maxlen[i] * target_width / total ))
    (( w < min_width )) && w=$min_width
    (( w > max_width )) && w=$max_width
    widths[i]=$w
    (( wsum += w ))
  done
  (( wsum == 0 )) && wsum=1
  for ((i = 0; i < num_cols; i++)); do
    local w=$(( widths[i] * target_width / wsum ))
    (( w < min_width )) && w=$min_width
    widths[i]=$w
  done

  echo -n '<table>'
  local first_row=1
  if [[ $has_header -eq 0 ]]; then
    echo -n '<tbody>'
  fi
  for row in "${rows[@]}"; do
    if [[ "$first_row" == "1" && $has_header -eq 0 ]]; then
      # The blank "| | |" header row itself carries no content - skip it
      # entirely rather than rendering an empty visible row above the data.
      first_row=0
      continue
    fi
    IFS=$'\x1f' read -r -a cells <<< "$row"
    if [[ "$first_row" == "1" && $has_header -eq 1 ]]; then
      echo -n '<thead><tr>'
      for ((i = 0; i < num_cols; i++)); do
        printf '<th data-colwidth="%s" data-background="%s"><p>%s</p></th>' "${widths[i]}" "$HEADER_BG" "$(inline_to_html "${cells[i]:-}")"
      done
      echo -n '</tr></thead><tbody>'
      first_row=0
    else
      first_row=0
      echo -n '<tr>'
      for ((i = 0; i < num_cols; i++)); do
        printf '<td data-colwidth="%s"><p>%s</p></td>' "${widths[i]}" "$(inline_to_html "${cells[i]:-}")"
      done
      echo -n '</tr>'
    fi
  done
  echo '</tbody></table>'
}

convert_csv_to_table() {
  local file="$1"
  local -a table_rows=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" ]] && continue
    parse_csv_line "$line"
    local joined="" first_field=1
    local val
    for val in "${CSV_FIELDS[@]}"; do
      if [[ "$first_field" == "1" ]]; then joined="$val"; first_field=0; else joined+=$'\x1f'"$val"; fi
    done
    joined+=$'\x1f.'
    table_rows+=("$joined")
  done < "$file"
  if [[ ${#table_rows[@]} -gt 0 ]]; then
    render_table "${table_rows[@]}"
  fi
}

convert_md_to_htmlplus() {
  local file="$1"
  local in_list=0
  local in_ol=0
  local paragraph=""
  local -a table_rows=()

  flush_paragraph() {
    if [[ -n "$paragraph" ]]; then
      echo "<p>$(inline_to_html "$paragraph")</p>"
      paragraph=""
    fi
  }
  close_list() {
    if [[ $in_list -eq 1 ]]; then
      echo "</ul>"
      in_list=0
    fi
    if [[ $in_ol -eq 1 ]]; then
      echo "</ol>"
      in_ol=0
    fi
  }
  flush_table() {
    if [[ -n "${table_open:-}" ]]; then
      if [[ ${#table_rows[@]} -gt 0 ]]; then
        render_table "${table_rows[@]}"
      fi
      table_rows=()
      unset table_open
    fi
  }

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^\|.*\|$ ]]; then
      # A real separator row always has at least one dash - a blank header
      # row like "| | |" (pipes and spaces only, no dash) is a legitimate
      # first row, not a separator, and must not be skipped here.
      if [[ "$line" =~ ^\|[-\ |]+\|$ ]] && [[ "$line" == *-* ]]; then
        continue
      fi
      close_list; flush_paragraph
      table_open=1
      IFS='|' read -r -a cells <<< "${line#|}"
      # The line's closing "|" produces one trailing empty field - drop only
      # that, not any cell that's legitimately blank (e.g. an intentionally
      # headerless "| | |" property table, or a blank data cell), which a
      # blanket empty-cell skip would silently delete and misalign columns.
      local n=${#cells[@]}
      if (( n > 0 )) && [[ -z "${cells[n-1]}" ]]; then
        unset 'cells[n-1]'
        cells=("${cells[@]}")
        n=${#cells[@]}
      fi
      local joined="" first_cell=1
      local ci trimmed
      for ((ci = 0; ci < n; ci++)); do
        trimmed=$(echo "${cells[ci]}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        if [[ "$first_cell" == "1" ]]; then joined="$trimmed"; first_cell=0; else joined+=$'\x1f'"$trimmed"; fi
      done
      joined+=$'\x1f.'
      table_rows+=("$joined")
      continue
    elif [[ -n "${table_open:-}" ]]; then
      flush_table
    fi

    if [[ "$line" =~ ^#\ (.+)$ ]]; then
      close_list; flush_paragraph
      echo "<h1>$(inline_to_html "${BASH_REMATCH[1]}")</h1>"
    elif [[ "$line" =~ ^##\ (.+)$ ]]; then
      close_list; flush_paragraph
      echo "<h2>$(inline_to_html "${BASH_REMATCH[1]}")</h2>"
    elif [[ "$line" =~ ^###\ (.+)$ ]]; then
      close_list; flush_paragraph
      echo "<h3>$(inline_to_html "${BASH_REMATCH[1]}")</h3>"
    elif [[ "$line" =~ ^####\ (.+)$ ]]; then
      close_list; flush_paragraph
      echo "<h4>$(inline_to_html "${BASH_REMATCH[1]}")</h4>"
    elif [[ "$line" =~ ^[0-9]+\.\ (.+)$ ]]; then
      flush_paragraph
      if [[ $in_list -eq 1 ]]; then echo "</ul>"; in_list=0; fi
      if [[ $in_ol -eq 0 ]]; then
        echo "<ol>"
        in_ol=1
      fi
      echo "<li><p>$(inline_to_html "${BASH_REMATCH[1]}")</p></li>"
    elif [[ "$line" =~ ^-\ (.+)$ ]]; then
      flush_paragraph
      if [[ $in_ol -eq 1 ]]; then echo "</ol>"; in_ol=0; fi
      if [[ $in_list -eq 0 ]]; then
        echo "<ul>"
        in_list=1
      fi
      echo "<li><p>$(inline_to_html "${BASH_REMATCH[1]}")</p></li>"
    elif [[ -z "$line" ]]; then
      close_list; flush_paragraph
    else
      if [[ -n "$paragraph" ]]; then
        paragraph="$paragraph $line"
      else
        paragraph="$line"
      fi
    fi
  done < "$file"
  close_list; flush_paragraph
  flush_table
}

if [[ "$MODE" == "csv" ]]; then
  convert_csv_to_table "$INPUT_FILE"
else
  convert_md_to_htmlplus "$INPUT_FILE"
fi
