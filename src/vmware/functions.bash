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
    -T)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        VM_CLI_VMRUN_ARGS+=("$1" "$2")
        shift
      fi
      ;;
    -gu | -gp | -vp)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        VM_CLI_VMRUN_ARGS+=("$1" "$2")
        shift
      fi
      ;;
    gui | nogui)
      VM_CLI_START_MODE="$1"
      ;;
    hard | soft)
      VM_CLI_STOP_MODE="$1"
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

  if [[ -z "$VM_CLI_START_MODE" ]]; then
    VM_CLI_START_MODE="nogui"
  fi

  if [[ -z "$VM_CLI_STOP_MODE" ]]; then
    VM_CLI_STOP_MODE="soft"
  fi
}

__vm_cli__set_vmx_path() {
  local vmx_path="$1"

  if [[ -z "$vmx_path" ]]; then
    if [[ -n "$VM_CLI_DEFAULT" ]]; then
      __vm_cli__message --info "Using the default $VM_CLI_DEFAULT virtual machine."
      vmx_path="$VM_CLI_DEFAULT"
    fi
  fi

  # If it's already a full path to .vmx file, use it directly
  if [[ "$vmx_path" == *.vmx && -f "$vmx_path" ]]; then
    VM_CLI_VMX_PATH="$vmx_path"
    VM_CLI_VM_NAME="$(basename "$vmx_path" .vmx)"
    return 0
  fi

  # If it's a VM name, try to find the .vmx file
  local base_path="$HOME/Virtual Machines.localized"
  local vmwarevm_path="$base_path/${vmx_path}.vmwarevm/${vmx_path}.vmx"

  if [[ -f "$vmwarevm_path" ]]; then
    VM_CLI_VMX_PATH="$vmwarevm_path"
    VM_CLI_VM_NAME="$vmx_path"
    return 0
  fi

  # If we can't find it, assume it's a path provided by user
  if [[ -n "$vmx_path" ]]; then
    VM_CLI_VMX_PATH="$vmx_path"
    VM_CLI_VM_NAME="$(basename "$vmx_path" .vmx)"
  fi

  if [[ -z "$VM_CLI_VMX_PATH" ]]; then
    __vm_cli__message --warning "Missing virtual machine path."
    exit 2
  fi

  if [[ ! -f "$VM_CLI_VMX_PATH" ]]; then
    __vm_cli__message --warning "Virtual machine file not found: $VM_CLI_VMX_PATH"
    exit 2
  fi
}

__vm_cli__is_running() {
  vmrun list | grep -q "$VM_CLI_VMX_PATH"
}
