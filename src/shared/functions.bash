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
  *) color_enabled=true ;;
  esac
  if [[ "$color_enabled" == true && "$(tput colors)" -ge 8 ]]; then
    VM_CLI_COLOR_WAIT="$(tput setaf 5)"
    VM_CLI_COLOR_INFO="$(tput setaf 6)"
    VM_CLI_COLOR_DONE="$(tput setaf 2)"
    VM_CLI_COLOR_WARNING="$(tput setaf 3)"
    VM_CLI_COLOR_FAILED="$(tput setaf 1)"
    VM_CLI_COLOR_RESET="$(tput sgr0)"
    VM_CLI_COLOR_VM="$(tput setaf 4)"
  fi
}
