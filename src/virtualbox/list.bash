# Build Priority: 5

__vm_cli__list() {
  local type="vms"
  if [[ -n "$1" && "$1" == "--running" ]]; then
    type="runningvms"
  fi
  VBoxManage list "$type" | awk '
BEGIN { nlen = 30 }
{
  name = $1
  gsub(/"/, "", name)
  names[NR] = name
  if (length(name) > nlen) {
    nlen = length(name)
  }
  uuid = $2
  gsub(/(\{|\})/, "", uuid)
  uuids[NR] = uuid
}
END {
  if (NR == 0) {
    print "No Virtual Machines found."
    exit 1
  }
  if (nlen > 30) {
    nlen += 2
  }
  printf "%-*s %s\n", nlen, "NAME", "UUID"
  for (i=1; i<=NR; i++) {
    printf "%-*s %s\n", nlen,  names[i], uuids[i]
  }
}'
  exit $?
}
