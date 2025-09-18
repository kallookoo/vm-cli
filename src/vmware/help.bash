# Build Priority: 4

__vm_cli__help() {
  case "${1:-help}" in
  usage)
    cat <<EOF
Usage: vm-cli-vmware [COMMAND] [FLAGS] [OPTIONS]
Run the 'vm-cli-vmware help' for information.
EOF
    ;;
  help)
    cat <<EOF
$(__vm_cli__help "usage" | sed 's/help/help command/g')

Environment:
VM_CLI_DEFAULT  Default Virtual Machine path (.vmx file).
VM_CLI_TIMEOUT  Max command execution time in seconds. Default: 30.
VM_CLI_COLOR    Set to false to disable color. Default: true.

Flags:
--vmx <path>     The Virtual Machine .vmx file path. Overrides VM_CLI_DEFAULT.
--timeout <int>  Attempt to execute, in seconds. Overrides VM_CLI_TIMEOUT.
--no-color       Disable the vm-cli color output. Overrides VM_CLI_COLOR.
-T <type>        VMware host type (fusion|ws). Default: fusion.
-gu <user>       Guest OS username for authentication.
-gp <pass>       Guest OS password for authentication.
-vp <pass>       Password for encrypted virtual machine.

Commands:
  help      Show this help message.
  version   Show version information.
  update    Updates vm-cli-vmware to the latest version.
  list      List all Virtual Machines.
  status    Show Virtual Machine running status.
  start     Start the Virtual Machine (nogui by default).
  stop      Stop the Virtual Machine (soft by default).
  suspend   Suspend the Virtual Machine.
  pause     Pause the Virtual Machine.
  unpause   Resume (unpause) the Virtual Machine.
  reset     Reset the Virtual Machine.
  ssh       SSH into the Virtual Machine using detected IP.
  ip        Show the IP address of the Virtual Machine.
EOF
    ;;
  start)
    cat <<EOF
start: Start the Virtual Machine (nogui by default).
  gui     Start with GUI (graphical interface).
  nogui   Start without GUI (headless mode). Default.
EOF
    ;;
  stop)
    cat <<EOF
stop: Stop the Virtual Machine (soft by default).
  soft    Graceful shutdown. Default.
  hard    Force power off immediately.
EOF
    ;;
  suspend)
    cat <<EOF
suspend: Suspend the Virtual Machine.
  soft    Graceful suspend. Default.
  hard    Force suspend immediately.
EOF
    ;;
  reset)
    cat <<EOF
reset: Reset the Virtual Machine.
  soft    Graceful reset. Default.
  hard    Force reset immediately.
EOF
    ;;
  list)
    cat <<EOF
list: List all Virtual Machines.
  --running  Show only running Virtual Machines.
EOF
    ;;
  ssh)
    cat <<EOF
ssh: SSH into the Virtual Machine using detected IP.
  --args <args> After this option, all arguments are passed to SSH.
If the Virtual Machine is not running, vm-cli will start it for you.
EOF
    ;;
  ip)
    cat <<EOF
ip: Show the IP address of the Virtual Machine.
If the Virtual Machine is not running, vm-cli will start it for you.
EOF
    ;;
  *)
    cat <<EOF
No help available for this command.
Try the vmrun documentation for more information:
https://docs.vmware.com/en/VMware-Fusion/
EOF
    ;;
  esac
  exit 0
}
