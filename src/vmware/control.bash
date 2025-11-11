# Build Priority: 7

__vm_cli__control() {
  local message
  case "$1" in
  pause | reset | stop | suspend)
    if ! __vm_cli__is_running; then
      __vm_cli__message --info "The virtual machine is stopped."
      return 0
    fi
    ;;
  unpause | start)
    if __vm_cli__is_running; then
      __vm_cli__message --info "The virtual machine is already running."
      return 0
    fi
    ;;
  *)
    # Pass unknown commands directly to vmrun
    __vm_cli__message --info "Executing vmrun command: $1"
    vmrun "${VM_CLI_START_ARGS[@]}" "$1" "$VM_CLI_VM_FULL_NAME" "${VM_CLI_ARGS[@]}"
    return $?
    ;;
  esac

  case "$1" in
  start)
    message="Starting the virtual machine."
    if ! [[ "${#VM_CLI_ARGS[@]}" =~ gui ]]; then
      VM_CLI_ARGS=("nogui" "${VM_CLI_ARGS[@]}")
    fi
    ;;
  pause) message="Pausing the virtual machine." ;;
  unpause) message="Resuming the virtual machine." ;;
  reset) message="Resetting the virtual machine." ;;
  stop) message="Stopping the virtual machine." ;;
  suspend) message="Suspending the virtual machine." ;;
  esac

  __vm_cli__message "$message"
  if vmrun "${VM_CLI_START_ARGS[@]}" "$1" "$VM_CLI_VM_FULL_NAME" "${VM_CLI_ARGS[@]}" >/dev/null 2>&1; then
    __vm_cli__message --done
    return 0
  fi
  __vm_cli__message --failed
  return 1
}
