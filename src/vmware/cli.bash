# Build Priority: 100

__vm_cli() {
  local color timeout vmx_path
  local cmd="usage"
  local stop_mode="soft"
  local parsed_args=()
  local exit_code=0
  local help_cmd="help"
  local help_found=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
    help) help_found=true ;;
    usage) __vm_cli__help "usage" ;;
    --no-color)
      color=false
      ;;
    --timeout)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        timeout="$2"
        shift
      fi
      ;;
    --vmx)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        vmx_path="$2"
        shift
      fi
      ;;
    -T | -gu | -gp | -vp)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        parsed_args+=("$1" "$2")
        shift
      fi
      ;;
    version | update | list | start | status | ip | ssh)
      cmd="$1"
      help_cmd="$1"
      ;;
    pause | unpause | reset | suspend)
      cmd="control"
      parsed_args+=("$1")
      help_cmd="$1"
      ;;
    stop)
      cmd="control"
      help_cmd="$1"
      if [[ -n "$2" && "$2" =~ ^-- ]]; then
        case "$2" in
        --hard)
          stop_mode="hard"
          ;;
        --soft)
          stop_mode="soft"
          ;;
        esac
        shift
      fi
      parsed_args+=("stop")
      ;;
    *) parsed_args+=("$1") ;;
    esac
    shift
  done

  if [[ "$help_found" == true ]]; then
    __vm_cli__help "$help_cmd"
  fi

  __vm_cli__set_color "$color"
  set -- "${parsed_args[@]}"

  case "$cmd" in
  version)
    __vm_cli__message --info "Version: $VM_CLI_VERSION."
    exit 0
    ;;
  update) __vm_cli__update "$@" ;;
  usage) __vm_cli__help "usage" ;;
  esac

  if ! command -v vmrun >/dev/null 2>&1; then
    __vm_cli__message --warning "vmrun command not found."
    exit 2
  fi

  # Initialize VMware-specific arrays
  VM_CLI_VMRUN_ARGS=()
  VM_CLI_ARGS=()

  # Set default VMware type
  if [[ " $* " != *" -T "* ]]; then
    VM_CLI_VMRUN_ARGS+=("-T" "fusion")
  fi

  if [[ "$cmd" == "list" ]]; then
    __vm_cli__list "$@"
  fi

  __vm_cli__set_vmx_path "$vmx_path"

  if [[ "$cmd" =~ ^(start|ip|ssh)$ ]]; then
    __vm_cli__set_args "$@"
    set -- "${VM_CLI_ARGS[@]}"
    __vm_cli__set_timeout "$timeout"
  fi

  # Set stop mode for control commands
  if [[ "$cmd" == "control" && "$stop_mode" != "soft" ]]; then
    VM_CLI_STOP_MODE="$stop_mode"
  fi

  case "$cmd" in
  control) __vm_cli__control "$@" ;;
  start) __vm_cli__start ;;
  status) __vm_cli__status ;;
  ip) __vm_cli__get_ip ;;
  ssh) __vm_cli__ssh "$@" ;;
  esac
  exit_code=$?
  exit $exit_code
}

__vm_cli "$@"
