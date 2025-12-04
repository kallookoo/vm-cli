# Build Priority: 9

__vm_cli__get_ip() {
  local ip pid tries=1
  local timeout=$VM_CLI_TIMEOUT
  local timeout_limit=60
  local exceeded=0
  local message

  if __vm_cli__control start; then
    __vm_cli__message "Retrieving IP address."

    vmrun "${VM_CLI_START_ARGS[@]}" getGuestIPAddress "$VM_CLI_VM_FULL_NAME" -wait >/dev/null 2>&1 &
    pid=$!

    while [[ $timeout_limit -ge $tries ]]; do
      if [[ $tries -gt $timeout ]]; then
        exceeded=$((tries - timeout))
        message="${VM_CLI_COLOR_WARNING}[$tries/$timeout_limit]${VM_CLI_COLOR_RESET} (timeout exceeded by $exceeded seconds)"
      else
        message="[$tries/$timeout]"
      fi
      __vm_cli__message "$message Retrieving IP address."
      ip="$(vmrun "${VM_CLI_START_ARGS[@]}" getGuestIPAddress "$VM_CLI_VM_FULL_NAME" 2>/dev/null)"
      if __vm_cli_validate_ipv4 "$ip"; then
        __vm_cli__message --done "Detected $ip IP address."
        return 0
      fi

      if ! kill -0 "$pid" >/dev/null 2>&1; then
        __vm_cli__message --warning "IP retrieval stopped due to a possible command failure."
        break
      fi
      ((tries++))
      sleep 1
    done
  fi
  __vm_cli__message --failed "Unable to obtain IP address."
  return 1
}
