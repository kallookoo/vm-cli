# Build Priority: 4

__vm_cli__help() {
  local cmd="${1:-help}"
  case "$cmd" in
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
--vm <name>      The Virtual Machine. Overrides the VM_CLI_DEFAULT.
--timeout <int>  Attempt to execute, in seconds. Overrides the VM_CLI_TIMEOUT.
--no-color       Disable the vm-cli color output. Overrides the VM_CLI_COLOR.

Commands:
  help      Show this help message.
  version   Show version information.
  update    Updates wm-cli to the latest version.
  list      List all Virtual Machines.
  status    Show Virtual Machine running status.
$(__vm_cli__help_commands)
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
  *)
    cat <<EOF
$(__vm_cli__help_commands "$cmd")
EOF
    ;;
  esac
  exit 0
}
