# Build Priority: 4

__vm_cli__help() {
  case "${1:-help}" in
  usage)
    cat <<EOF
Usage: vm-cli [COMMAND] [FLAGS] [OPTIONS]
Run the 'vm-cli help' for information.
EOF
    ;;
  help)
    cat <<EOF
$(__vm_cli__help "usage" | sed 's/help/help command/g')

Environment:
VM_CLI_DEFAULT  Default Virtual Machine.
VM_CLI_TIMEOUT  Max command execution time in seconds. Default: 30.
VM_CLI_COLOR    Set to false to disable color. Default: true.

Flags:
--vm <name|uuid> The Virtual Machine. Overrides the VM_CLI_DEFAULT.
--timeout <int>  Attempt to execute, in seconds. Overrides the VM_CLI_TIMEOUT.
--no-color       Disable the vm-cli color output. Overrides the VM_CLI_COLOR.

Commands:
  help      Show this help message.
  version   Show version information.
  update    Updates wm-cli to the latest version.
  list      List all Virtual Machines.
  status    Show Virtual Machine running status.
  start     Start the Virtual Machine in headless by default.
  stop      Stop the Virtual Machine (saves state by default).
  save      Save the Virtual Machine state.
  sleep     Sleep the Virtual Machine.
  poweroff  Power off the Virtual Machine immediately.
  shutdown  Asks the guest OS to shutdown.
  pause     Pause the Virtual Machine.
  resume    Resume the Virtual Machine.
  reboot    Reboot the virtual machine.
  control   Pass the command directly to VBoxManage controlvm.
  ssh       SSH into the Virtual Machine using the Host-Only IP.
  ip        Show the Host-Only IP address of the Virtual Machine.
EOF
    ;;
  update)
    cat <<EOF
update: Updates wm-cli to the latest version.
  --token <token>  Specify the GitHub token for authentication.
                   Required if you are rate limited by the GitHub API.
EOF
    ;;
  list)
    cat <<EOF
list: List all Virtual Machines.
  --running  Show only running Virtual Machines.
EOF
    ;;
  start)
    cat <<EOF
start: Start the Virtual Machine in headless by default.
  --type <type>           The type of the Virtual Machine. Default: headless.
  -E, --putenv <var=val>  Set the environment variable for the Virtual Machine.
  --password <pass-file>  Set the password file for the Virtual Machine.
  --password-id <id>      Set the password ID for the Virtual Machine.
EOF
    ;;
  stop)
    cat <<EOF
stop: Stop the Virtual Machine (saves state by default).
  --save      Save the Virtual Machine state.
  --acpi      Send ACPI power button signal.
  --sleep     Send ACPI sleep signal.
  --poweroff  Power off the Virtual Machine immediately.
EOF
    ;;
  save)
    cat <<EOF
save: Save the Virtual Machine state.
This is an alias for 'stop --save'.
EOF
    ;;
  sleep)
    cat <<EOF
sleep: Sleep the Virtual Machine.
This is an alias for 'stop --sleep'.
EOF
    ;;
  poweroff)
    cat <<EOF
poweroff: Power off the Virtual Machine immediately.
This is an alias for 'stop --poweroff'.
EOF
    ;;
  shutdown)
    cat <<EOF
shutdown: Asks the guest OS to shutdown.
  --force  Force the shutdown of the Virtual Machine.
EOF
    ;;
  control)
    cat <<EOF
control: Pass the command directly to VBoxManage controlvm.
For more information, see the VBoxManage documentation:
https://www.virtualbox.org/manual/ch08.html#vboxmanage-controlvm
EOF
    ;;
  ssh)
    cat <<EOF
ssh: SSH into the Virtual Machine using the Host-Only IP.
  --args <args> After this option, all arguments are passed to SSH.
If the Virtual Machine is not running, vm-cli will start it for you.
You can add start options if your Virtual Machine needs special parameters.
EOF
    ;;
  ip)
    cat <<EOF
ip: Show the Host-Only IP address of the Virtual Machine.
If the Virtual Machine is not running, vm-cli will start it for you.
You can add start options if your Virtual Machine needs special parameters.
EOF
    ;;
  *)
    cat <<EOF
No help available for this command.
Try the VBoxManage documentation for more information:
https://www.virtualbox.org/manual/ch08.html
EOF
    ;;
  esac
  exit 0
}
