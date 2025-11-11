# Build Priority: 2.1

__vm_cli__set_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -T | -gu | -gp | -vp)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        VM_CLI_START_ARGS+=("$1" "$2")
        shift
      fi
      ;;
    --gui | --nogui | --hard | --soft)
      VM_CLI_ARGS+=("${1#--}")
      ;;
    --)
      shift
      VM_CLI_ARGS+=("$@")
      break
      ;;
    *) VM_CLI_ARGS+=("$1") ;;
    esac
    shift
  done

  if [[ " ${VM_CLI_START_ARGS[*]} " != *"-T"* ]]; then
    VM_CLI_START_ARGS+=("-T" "fusion")
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
  if [[ -n "$name" ]]; then
    name="$(echo "$name" | awk -F"/" '{gsub(/\.vmx/, "", $NF); print $NF}')"
    if [[ -f "$HOME/Virtual Machines.localized/$name.vmwarevm/$name.vmx" ]]; then
      VM_CLI_VM_FULL_NAME="$HOME/Virtual Machines.localized/$name.vmwarevm/$name.vmx"
    fi
  fi

  if [[ -z "$VM_CLI_VM_FULL_NAME" ]]; then
    __vm_cli__message --warning "Missing virtual machine name."
    exit 2
  fi
  VM_CLI_VM_NAME="$(basename "$VM_CLI_VM_FULL_NAME" ".vmx")"
}

__vm_cli__is_running() {
  vmrun list | grep -q "$VM_CLI_VM_FULL_NAME"
}
