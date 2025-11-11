# Build Priority: 5

__vm_cli__list() {
  local item items=()
  if [[ -n "$1" && "$1" == "--running" ]]; then
    while read -r item; do
      items+=("$item")
    done < <(vmrun list | awk '/^Total/ {next} {print $0}')
  else
    while read -r item; do
      items+=("$item")
    done < <(find "$HOME/Virtual Machines.localized" -name "*.vmx" -print 2>/dev/null)
  fi
  if [[ ${#items[@]} -eq 0 ]]; then
    echo "No Virtual Machines found."
    exit 1
  fi
  echo "${items[@]}" | awk -F"/" '
BEGIN { nlen = 30 }
{
  name = $NF
  gsub(/\.vmx/, "", name)
  names[NR] = name
  if (length(name) > nlen) {
    nlen = length(name)
  }
  paths[NR] = $0
}
END {
  if (NR == 0) {
    print "No Virtual Machines found."
    exit 1
  }
  if (nlen > 30) {
    nlen += 2
  }
  printf "%-*s %s\n", nlen, "NAME", "PATH"
  for (i=1; i<=NR; i++) {
    printf "%-*s %s\n", nlen,  names[i], paths[i]
  }
}'
  exit $?
}
