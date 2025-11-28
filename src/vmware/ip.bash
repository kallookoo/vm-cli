# Build Priority: 9

__vm_cli__get_ip() {
  local ip pid tries=1
  local timeout=$VM_CLI_TIMEOUT

  if __vm_cli__control start; then
    __vm_cli__message "Retrieving IP address."
    if [[ $timeout -lt 60 ]]; then
      timeout=60
      __vm_cli__message --info "Timeout temporarily adjusted to $timeout due to limitations."
    fi

    vmrun "${VM_CLI_START_ARGS[@]}" getGuestIPAddress "$VM_CLI_VM_FULL_NAME" -wait >/dev/null 2>&1 &
    pid=$!

    while [[ $timeout -ge $tries ]]; do
      __vm_cli__message "[$tries/$timeout] Retrieving IP address."
      ip="$(vmrun "${VM_CLI_START_ARGS[@]}" getGuestIPAddress "$VM_CLI_VM_FULL_NAME" 2>/dev/null)"
      if [[ -n "$ip" && "$ip" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
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
