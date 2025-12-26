# Build Priority: 100

__vm_cli() {
  local color timeout name
  local cmd="usage"
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
    --vm)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        name="$2"
        shift
      fi
      ;;
    -T | -gu | -gp | -vp)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        parsed_args+=("$1" "$2")
        shift
      fi
      ;;
    version | update | list | status | ip | ssh)
      cmd="$1"
      help_cmd="$1"
      ;;
    start | pause | unpause | reset | suspend | stop | control)
      cmd="$1"
      help_cmd="$1"
      if [[ -n "$2" && "$2" =~ ^--(hard|soft|gui|nogui) ]]; then
        parsed_args+=("${2#--}")
        shift
      fi
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

  __vm_cli__update_path
  if ! command -v vmrun >/dev/null 2>&1; then
    __vm_cli__message --warning "vmrun command not found."
    exit 2
  fi

  if [[ "$cmd" == "list" ]]; then
    __vm_cli__list "$@"
  fi

  __vm_cli__set_name "$name"
  if [[ "$cmd" != "status" ]]; then
    __vm_cli__set_args "$@"
    set -- "${VM_CLI_ARGS[@]}"
    __vm_cli__set_timeout "$timeout"
  fi

  case "$cmd" in
  start | pause | unpause | reset | suspend | stop) __vm_cli__control "$cmd" "$@" ;;
  control) __vm_cli__control "$@" ;;
  status) __vm_cli__status ;;
  ip) __vm_cli__get_ip ;;
  ssh) __vm_cli__ssh "$@" ;;
  esac
  exit_code=$?
  exit $exit_code
}

__vm_cli "$@"
