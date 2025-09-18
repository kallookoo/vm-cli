# Build Priority: 1

# Readonly

# The version of the CLI
readonly VM_CLI_VERSION="2.0.0"

# See the function __vm_cli__update
VM_CLI_INSTALL_PATH="$(dirname "${BASH_SOURCE[0]:-0}")"
readonly VM_CLI_INSTALL_PATH

# Set the defaults

# See the function __vm_cli_set_timeout
: VM_CLI_TIMEOUT=30

# See the function __vm_cli_set_color
: VM_CLI_COLOR=true

# See the function __vm_cli__detect_hypervisor
: VM_CLI_HYPERVISOR=auto

# Set the empty values

# See the function __vm_cli__set_color
VM_CLI_COLOR_WAIT=""
VM_CLI_COLOR_INFO=""
VM_CLI_COLOR_DONE=""
VM_CLI_COLOR_WARNING=""
VM_CLI_COLOR_FAILED=""
VM_CLI_COLOR_RESET=""
VM_CLI_COLOR_VM=""

# See the function __vm_cli__set_args
VM_CLI_ARGS=()
VM_CLI_START_ARGS=()

# See the function __vm_cli__message
VM_CLI_CURRENT_MESSAGE=""
VM_CLI_LATEST_MESSAGE=""

# See the function __vm_cli__set_name
VM_CLI_VM_NAME=""
