#!/usr/bin/env bash

__vm_cli__get_modified_at() {
  local epoch file="$1"
  if ! epoch="$(git log --follow -1 --format=%ct -- "$file" 2>/dev/null)"; then
    date -r "$file" -u +'%Y-%m-%d %H:%M:%S %Z'
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    date -r "$epoch" -u +'%Y-%m-%d %H:%M:%S %Z'
  else
    date -d "@$epoch" -u +'%Y-%m-%d %H:%M:%S %Z'
  fi
}

__vm_cli_compile() {
  local dest compiled_at component priority hypervisor src install=false
  local items=()
  components=()
  compiled_at="$(date -u +'%Y-%m-%d %H:%M:%S %Z')"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --install)
      install=true
      ;;
    --hypervisor)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        hypervisor="$2"
        shift
      fi
      ;;
    virtualbox | vmware)
      hypervisor="$1"
      ;;
    esac
    shift
  done

  if [[ -z "$hypervisor" ]]; then
    echo "Error: --hypervisor <virtualbox|vmware> is required."
    return 1
  fi

  mkdir -p "dist/$hypervisor"
  dest="dist/$hypervisor/vm-cli"

  for src in src/shared src/"$hypervisor"; do
    for component in "$src"/*.bash; do
      priority="$(awk -F: '/Priority/ {print $2; exit}' "$component")"
      items+=("$priority@$component")
    done
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
        -v modified_at="$(__vm_cli__get_modified_at "$component")" \
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
  if [[ "$install" == true && -d "$HOME/.local/bin" ]]; then
    cp -f "$dest" "$HOME/.local/bin/vm-cli"
    echo "Installed to $HOME/.local/bin/vm-cli"
  fi
  return 0
}

__vm_cli_compile "$@"
exit $?
