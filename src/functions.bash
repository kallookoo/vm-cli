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

__vm_cli__set_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --type | --putenv | --password | --password-id)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        VM_CLI_START_ARGS+=("$1" "$2")
        shift
      fi
      ;;
    -E)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        if [[ "$2" =~ ^([^=]+)=([^=]+)$ ]]; then
          VM_CLI_START_ARGS+=("$1" "$2")
        else
          VM_CLI_ARGS+=("$1" "$2")
        fi
        shift
      fi
      ;;
    --args)
      shift
      VM_CLI_ARGS+=("$@")
      break
      ;;
    *) VM_CLI_ARGS+=("$1") ;;
    esac
    shift
  done

  if [[ " ${VM_CLI_START_ARGS[*]} " != *"--type"* ]]; then
    VM_CLI_START_ARGS+=("--type" "headless")
  fi
}

__vm_cli__set_name() {
  local name
  if [[ -n "$1" ]]; then
    name="$1"
  elif [[ -n "$VM_CLI_DEFAULT" ]]; then
    __vm_cli__message --info "Using the default $VM_CLI_DEFAULT virtual machine."
    name="$VM_CLI_DEFAULT"
  fi

  # Validate the default or provided VM name and set it.
  if [[ -n "$name" ]] && VBoxManage list vms | grep -q "\"$name\""; then
    VM_CLI_VM_NAME="$name"
  fi

  if [[ -z "$VM_CLI_VM_NAME" ]]; then
    __vm_cli__message --warning "Missing virtual machine name."
    exit 2
  fi
}

__vm_cli__is_running() {
  VBoxManage list runningvms | grep -q "\"$VM_CLI_VM_NAME\""
}
