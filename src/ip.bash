# Build Priority: 9

__vm_cli__get_ip() {
  local index ip tries=1
  if __vm_cli__start; then
    __vm_cli__message "Retrieving IP address."
    while [[ $VM_CLI_TIMEOUT -ge $tries ]]; do
      if [[ -z "$index" ]]; then
        index="$(VBoxManage showvminfo "$VM_CLI_VM_NAME" --machinereadable | awk -F= '$2 ~ /hostonly/ {sub(/[^0-9]+/, "", $1); print $1-1; exit}')"
      fi
      ip="$(VBoxManage guestproperty enumerate "$VM_CLI_VM_NAME" "*Net/$index/*" | awk -F"'" '$2 ~ /Up/ {found=1}; found && $1 ~ /IP/ {print $2; exit}')"
      if [[ -n "$ip" ]]; then
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
