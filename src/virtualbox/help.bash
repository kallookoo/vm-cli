# Build Priority: 3.9

__vm_cli__help_commands() {
  case "${1:-help}" in
  help)
    cat <<EOF
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
  -- <args> After this option, all arguments are passed to SSH.
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
