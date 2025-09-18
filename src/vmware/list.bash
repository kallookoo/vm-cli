# Build Priority: 5

__vm_cli__list() {
  local show_all=true
  if [[ -n "$1" && "$1" == "--running" ]]; then
    show_all=false
  fi

  if [[ "$show_all" == true ]]; then
    # List all VMs by searching common VMware directories
    local common_paths=(
      "$HOME/Virtual Machines.localized"
    )

    local found_vms=()
    for base_path in "${common_paths[@]}"; do
      if [[ -d "$base_path" ]]; then
        while IFS= read -r -d '' vmx_file; do
          found_vms+=("$vmx_file")
        done < <(find "$base_path" -name "*.vmx" -print0 2>/dev/null)
      fi
    done

    if [[ ${#found_vms[@]} -eq 0 ]]; then
      echo "No Virtual Machines found."
      exit 1
    fi

    local max_len=4 # Length of "NAME"
    local vm_names=()
    local vm_paths=()

    for vmx_file in "${found_vms[@]}"; do
      local vm_name="$(basename "$vmx_file" .vmx)"
      vm_names+=("$vm_name")
      vm_paths+=("$vmx_file")
      if [[ ${#vm_name} -gt $max_len ]]; then
        max_len=${#vm_name}
      fi
    done

    printf "%-*s %s\n" $((max_len + 2)) "NAME" "PATH"
    for i in "${!vm_names[@]}"; do
      printf "%-*s %s\n" $((max_len + 2)) "${vm_names[$i]}" "${vm_paths[$i]}"
    done
  else
    # List only running VMs
    vmrun list | tail -n +2 | awk '
    BEGIN {
      nlen = 4  # Length of "NAME"
      count = 0
    }
    {
      vm_path = $0
      split(vm_path, path_parts, "/")
      vm_file = path_parts[length(path_parts)]
      gsub(/\.vmx$/, "", vm_file)
      vm_names[count] = vm_file
      vm_paths[count] = vm_path
      if (length(vm_file) > nlen) {
        nlen = length(vm_file)
      }
      count++
    }
    END {
      if (count == 0) {
        print "No running Virtual Machines found."
        exit 1
      }
      printf "%-*s %s\n", nlen + 2, "NAME", "PATH"
      for (i = 0; i < count; i++) {
        printf "%-*s %s\n", nlen + 2, vm_names[i], vm_paths[i]
      }
    }'
  fi
  exit $?
}
