# Build Priority: 3

__vm_cli__message() {
  local header message
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --info) header="${VM_CLI_COLOR_INFO}[INFO]${VM_CLI_COLOR_RESET}" ;;
    --done) header="${VM_CLI_COLOR_DONE}[DONE]${VM_CLI_COLOR_RESET}" ;;
    --failed) header="${VM_CLI_COLOR_FAILED}[FAILED]${VM_CLI_COLOR_RESET}" ;;
    --warning) header="${VM_CLI_COLOR_WARNING}[WARNING]${VM_CLI_COLOR_RESET}" ;;
    *) VM_CLI_CURRENT_MESSAGE="$1" ;;
    esac
    shift
  done
  message="$(echo "$VM_CLI_CURRENT_MESSAGE" | xargs)"
  if [[ -z "$header" ]]; then
    header="${VM_CLI_COLOR_WAIT}[WAIT]${VM_CLI_COLOR_RESET}"
  elif ! [[ -p /dev/stdout ]]; then
    message+=$'\n'
  fi
  if [[ -n "$VM_CLI_VM_NAME" ]]; then
    header="${VM_CLI_COLOR_VM}[${VM_CLI_VM_NAME}]${VM_CLI_COLOR_RESET} $header"
  fi
  VM_CLI_LATEST_MESSAGE="$header $message"
  # Print the messages
  if [ -t 1 ]; then # TTY - Terminal
    printf "\r$(tput el)%b" "$VM_CLI_LATEST_MESSAGE"
  elif [ -p /dev/stdout ]; then # Pipe - Pipe to another command
    printf "%b" "${VM_CLI_LATEST_MESSAGE}\n"
  else # Redirect - Redirect to a file, uses stderr to print the message.
    printf "\r$(tput el)%b" "$VM_CLI_LATEST_MESSAGE" >&2
  fi
}
