#!/usr/bin/env bash

__vm_cli_compile() {
  local compiled_at component priority
  local dest="dist/vm-cli"
  local items=()
  components=()
  compiled_at="$(date -u +'%Y-%m-%d %H:%M:%S %Z')"

  [ -d dist ] || mkdir dist

  for component in src/*.bash; do
    priority="$(awk -F: '/Priority/ {print $2; exit}' "$component")"
    items+=("$priority@$component")
  done

  while read -r component; do
    components+=("${component#*@}")
  done < <(printf '%s\n' "${items[@]}" | sort -t '@' -k 1 -n)

  if [[ ${#components[@]} -eq 0 ]]; then
    echo "No components found."
    return 1
  fi

  cat <<EOF >"$dest"
#!/usr/bin/env bash
# This file is auto-generated. Compiled at: $compiled_at
$(
    for component in "${components[@]}"; do
      awk \
        -v name="$(echo "$component" | sed -E 's|.*/([0-9]+-)?([^-\.]+)\.[^\.]+$|\2|')" \
        -v modified_at="$(date -r "$component" -u +'%Y-%m-%d %H:%M:%S %Z')" \
        '
      BEGIN { print "# Component: " name " at " modified_at }
      /cat <<EOF/ {in_heredoc=1; print; next}
      /^EOF$/ && in_heredoc {print; in_heredoc=0; next}
      in_heredoc {print; next}
      $1 !~ /^#/ && NF {
        line = $0
        if ( match(line, /[[:space:]]#/) ) {
          line = substr(line, 0, RSTART)
        }
        print line
      }
      ' "$component"
    done
  )
EOF
  chmod +x "$dest"
  echo "Compiled completed."
  if [[ "$1" == "--install" && -d "$HOME/.local/bin" ]]; then
    cp -f "$dest" "$HOME/.local/bin/vm-cli"
    echo "Installed to $HOME/.local/bin/vm-cli"
  fi
  return 0
}

__vm_cli_compile "$@"
exit $?
