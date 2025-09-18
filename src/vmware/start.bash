# Build Priority: 8

__vm_cli__start() {
  if __vm_cli__is_running; then
    __vm_cli__message --info "The virtual machine is already running."
    return 0
  fi
  __vm_cli__message "Starting the virtual machine."
  if vmrun "${VM_CLI_VMRUN_ARGS[@]}" start "$VM_CLI_VMX_PATH" "$VM_CLI_START_MODE" >/dev/null 2>&1; then
    __vm_cli__message --done
    return 0
  fi
  __vm_cli__message --failed
  return 1
}
