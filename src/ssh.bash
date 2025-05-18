# Build Priority: 10

__vm_cli__wait_ssh() {
  local host="$1"
  local ip="$2"
  local tries=1
  local message="Connecting to $host"
  if [[ "$host" != "$ip" ]]; then
    message="Connecting to $host ($ip)"
  fi

  __vm_cli__message "$message."

  while [[ $VM_CLI_TIMEOUT -ge $tries ]]; do
    if ssh -q -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=1 "$host" 'exit 0'; then
      __vm_cli__message --done "Connected."
      return 0
    fi
    __vm_cli__message "[$tries/$VM_CLI_TIMEOUT] $message."
    ((tries++))
    sleep 1
  done

  __vm_cli__message --failed "Connection is not available."
  return 1
}

__vm_cli__ssh() {
  local ssh_config="$HOME/.ssh/config"
  local ip host host_name

  if ! __vm_cli__get_ip; then
    return 1
  fi

  ip="$(printf "%b" "$VM_CLI_LATEST_MESSAGE" | awk '/DONE/ {print $(NF-2)}')"
  if ! [[ -n "$ip" && "$ip" =~ ^192(\.[0-9]{1,3}){3}$ ]]; then
    __vm_cli__message --failed "No valid IPv4 available."
    return 1
  fi

  host="$ip"
  if [[ -f "$ssh_config" ]] && grep -q "$ip" "$ssh_config"; then
    host_name=$(tail -r "$ssh_config" | awk -v ip="$ip" 'found && $1 == "Host" {print $2; exit}; $1 == "HostName" && $2 == ip {found=1}')
    if [ -n "$host_name" ]; then
      host="$host_name"
      __vm_cli__message --info "Using $host Host as alias for $ip."
    fi
  fi

  if __vm_cli__wait_ssh "$host" "$ip"; then
    ssh -t "$host" "$@"
    return $?
  fi

  return 1
}
