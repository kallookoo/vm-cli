# Build Priority: 3.9

__vm_cli__help_commands() {
  case "${1:-help}" in
  help)
    cat <<EOF
  start     Start the Virtual Machine (--nogui by default).
  stop      Stop the Virtual Machine (--soft by default).
  poweroff  Power off the Virtual Machine immediately.
  shutdown  Asks the guest OS to shutdown.
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
start: Start the Virtual Machine (--nogui by default).
  --gui     Start with GUI (graphical interface).
  --nogui   Start without GUI (headless mode). Default.
EOF
    ;;
  stop)
    cat <<EOF
stop: Stop the Virtual Machine (--soft by default).
  --soft    Graceful shutdown. Default.
  --hard    Force power off immediately.
EOF
    ;;
  poweroff)
    cat <<EOF
poweroff: Power off the Virtual Machine immediately.
This is an alias for 'stop --hard'.
EOF
    ;;
  shutdown)
    cat <<EOF
shutdown: Asks the guest OS to shutdown.
This is an alias for 'stop --soft'.
EOF
    ;;
  suspend)
    cat <<EOF
suspend: Suspend the Virtual Machine.
  --soft    Graceful suspend. Default.
  --hard    Force suspend immediately.
EOF
    ;;
  reset)
    cat <<EOF
reset: Reset the Virtual Machine.
  --soft    Graceful reset. Default.
  --hard    Force reset immediately.
EOF
    ;;
  control)
    cat <<EOF
control: Pass the command directly to vmrun command.
For more information, see the VMware documentation:
https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors.html
EOF
    ;;
  ssh)
    cat <<EOF
ssh: SSH into the Virtual Machine using detected IP.
  -- <args> After this option, all arguments are passed to SSH.
If the Virtual Machine is not running, vm-cli will start it for you.
You can add start options if your Virtual Machine needs special parameters.
EOF
    ;;
  ip)
    cat <<EOF
ip: Show the IP address of the Virtual Machine.
If the Virtual Machine is not running, vm-cli will start it for you.
You can add start options if your Virtual Machine needs special parameters.
EOF
    ;;
  *)
    cat <<EOF
No help available for this command.
Try the VMware documentation for more information:
https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors.html
EOF
    ;;
  esac
  exit 0
}
