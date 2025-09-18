# Build Priority: 7

__vm_cli__control() {
  local message
  case "$1" in
  pause | reset | poweroff | savestate | acpipowerbutton | acpisleepbutton | shutdown | reboot)
    if ! __vm_cli__is_running; then
      __vm_cli__message --info "The virtual machine is stopped."
      return 1
    fi
    ;;
  resume)
    if __vm_cli__is_running; then
      __vm_cli__message --info "The virtual machine is already running."
      return 1
    fi
    ;;
  *)
    # Pass the another subcommand directly to VBoxManage.
    __vm_cli__message --info "Executing the controlvm command: $1"
    VBoxManage controlvm "$VM_CLI_VM_NAME" "$@"
    return $?
    ;;
  esac
  case "$1" in
  pause) message="Pausing the virtual machine." ;;
  reset) message="Resetting the virtual machine." ;;
  poweroff) message="Powering off the virtual machine." ;;
  savestate) message="Saving the virtual machine state." ;;
  acpipowerbutton) message="Sending ACPI power button signal." ;;
  acpisleepbutton) message="Sending ACPI sleep button signal." ;;
  shutdown) message="Shutting down the virtual machine." ;;
  resume) message="Resuming the virtual machine." ;;
  reboot) message="Rebooting the virtual machine." ;;
  esac
  __vm_cli__message "$message"
  if VBoxManage controlvm "$VM_CLI_VM_NAME" "$@" >/dev/null 2>&1; then
    __vm_cli__message --done
    return 0
  fi
  __vm_cli__message --failed
  return 1
}
