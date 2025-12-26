# Build Priority: 2

__vm_cli__set_timeout() {
  local timeout=30
  VM_CLI_TIMEOUT="${1:-$VM_CLI_TIMEOUT}"
  # Check if it's a number
  if ! [[ "$VM_CLI_TIMEOUT" =~ ^[0-9]+$ ]]; then
    VM_CLI_TIMEOUT="$timeout"
  fi
}

__vm_cli__set_color() {
  local color_enabled=true
  VM_CLI_COLOR="${1:-$VM_CLI_COLOR}"
  case "$VM_CLI_COLOR" in
  false | no) color_enabled=false ;;
  esac
  if [[ "$color_enabled" == true && -t 1 ]]; then
    VM_CLI_COLOR_WAIT="\e[35m"    # magenta
    VM_CLI_COLOR_INFO="\e[36m"    # cyan
    VM_CLI_COLOR_DONE="\e[32m"    # green
    VM_CLI_COLOR_WARNING="\e[33m" # yellow
    VM_CLI_COLOR_FAILED="\e[31m"  # red
    VM_CLI_COLOR_RESET="\e[0m"    # reset
    VM_CLI_COLOR_VM="\e[34m"      # blue
  fi
}

__vm_cli_validate_ipv4() {
  local ip=$1
  # Reset the detected IP.
  VM_CLI_VM_DETECTED_IP=""

  echo "$ip" | awk -F. '
NF == 4 {
  for (i = 1; i <= 4; i++) {
    if ($i !~ /^[0-9]+$/ || $i < 0 || $i > 255) exit 1
  }
  if ($1 == 0 || $1 == 127 || $1 >= 224 || $4 == 0 || $4 == 255) exit 1
  exit 0
}
{ exit 1 }
' >/dev/null 2>&1 && {
    VM_CLI_VM_DETECTED_IP="$ip"
    return 0
  }
  return 1
}
