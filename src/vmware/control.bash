# Build Priority: 7

__vm_cli__control() {
  local message
  case "$1" in
  pause | reset | stop | suspend)
    if ! __vm_cli__is_running; then
      __vm_cli__message --info "The virtual machine is stopped."
      return 1
    fi
    ;;
  unpause)
    # VMware uses unpause instead of resume
    if __vm_cli__is_running; then
      __vm_cli__message --info "The virtual machine is already running."
      return 1
    fi
    ;;
  *)
    # Pass unknown commands directly to vmrun
    __vm_cli__message --info "Executing vmrun command: $1"
    vmrun "${VM_CLI_VMRUN_ARGS[@]}" "$@" "$VM_CLI_VMX_PATH"
    return $?
    ;;
  esac

  case "$1" in
  pause) message="Pausing the virtual machine." ;;
  unpause) message="Resuming the virtual machine." ;;
  reset) message="Resetting the virtual machine ($VM_CLI_STOP_MODE)." ;;
  stop) message="Stopping the virtual machine ($VM_CLI_STOP_MODE)." ;;
  suspend) message="Suspending the virtual machine ($VM_CLI_STOP_MODE)." ;;
  esac

  __vm_cli__message "$message"
  local cmd_args=("${VM_CLI_VMRUN_ARGS[@]}" "$1")

  # Add VMX path
  cmd_args+=("$VM_CLI_VMX_PATH")

  # Add mode for commands that support it
  case "$1" in
  reset | stop | suspend)
    cmd_args+=("$VM_CLI_STOP_MODE")
    ;;
  esac

  if vmrun "${cmd_args[@]}" >/dev/null 2>&1; then
    __vm_cli__message --done
    return 0
  fi
  __vm_cli__message --failed
  return 1
}
