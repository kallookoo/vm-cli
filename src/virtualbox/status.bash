# Build Priority: 6

__vm_cli__status() {
  local status="stopped"
  __vm_cli__is_running && status="running"
  __vm_cli__message --info "The virtual machine is $status."
  return 0
}
