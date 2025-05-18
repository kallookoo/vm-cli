# Build Priority: 8

__vm_cli__start() {
  if __vm_cli__is_running; then
    __vm_cli__message --info "The virtual machine is already running."
    return 0
  fi
  __vm_cli__message "Initiating the virtual machine."
  if VBoxManage startvm "$VM_CLI_VM_NAME" "${VM_CLI_START_ARGS[@]}" >/dev/null 2>&1; then
    __vm_cli__message --done
    return 0
  fi
  __vm_cli__message --failed
  return 1
}
