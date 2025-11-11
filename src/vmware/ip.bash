# Build Priority: 9

__vm_cli__get_ip() {
  local tries=1
  if __vm_cli__control start; then
    __vm_cli__message "Retrieving IP address."
    while [[ $VM_CLI_TIMEOUT -ge $tries ]]; do
      local ip
      ip="$(vmrun "${VM_CLI_START_ARGS[@]}" getGuestIPAddress "$VM_CLI_VM_FULL_NAME" -wait 2>/dev/null)"
      if [[ -n "$ip" && "$ip" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
        __vm_cli__message --done "Detected $ip IP address."
        return 0
      fi

      __vm_cli__message "[$tries/$VM_CLI_TIMEOUT] Retrieving IP address."
      ((tries++))
      sleep 1
    done
  fi
  __vm_cli__message --failed "Unable to obtain IP address."
  return 1
}
