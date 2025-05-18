# Build Priority: 11

__vm_cli__update() {
  local token response version cmd exit_code=0
  local repository="kallookoo/vm-cli"
  local api_url="https://api.github.com/repos/$repository/releases/latest"

  for cmd in curl tar; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      __vm_cli__message --failed "Then $cmd command is required but not installed."
      exit 1
    fi
  done

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --token)
      if [[ -n "$2" ]] && ! [[ "$2" =~ ^- ]]; then
        token="$2"
        shift
      fi
      ;;
    esac
    shift
  done

  __vm_cli__message --info "Checking the latest version."

  response="$(curl -sfL "$api_url")"
  exit_code=$?

  if echo "$response" | grep -q "API rate limit exceeded"; then
    if [[ -z "$token" ]]; then
      __vm_cli__message --warning "GitHub API rate limit exceeded. Please provide a token."
      exit 1
    fi
    response="$(curl -sfL -H "Authorization: Bearer $token" "$api_url")"
    exit_code=$?
  fi

  if [[ "$exit_code" -ne 0 || -z "$response" ]]; then
    __vm_cli__message --failed "Failed to fetch the latest version."
    exit 2
  fi

  # Extracts the latest version using jq, awk, or sed.
  if command -v jq >/dev/null 2>&1; then
    version=$(jq -n "$response" | jq -r '.tag_name')
  elif command -v awk >/dev/null 2>&1; then
    version=$(echo "$response" | awk -F: '$1 ~ /tag_name/ {gsub(/[^v0-9\.]+/, "", $2) ;print $2; exit}')
  elif command -v sed >/dev/null 2>&1; then
    version=$(echo "$response" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
  else
    __vm_cli__message --failed "sed, awk, or jq is required to perform the update."
    exit 2
  fi

  if [[ -z "$version" ]] || ! [[ "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    __vm_cli__message --failed "There was an error trying to check what is the latest version."
    exit 2
  fi

  version="${version#v}"
  if [[ "$VM_CLI_VERSION" == "$version" ]]; then
    __vm_cli__message --info "Already use the latest version."
    exit 0
  fi

  __vm_cli__message --info "Updating to $version version."
  curl -sfL "https://github.com/$repository/releases/download/v$version/vm-cli.tar.gz" |
    tar -xzf - -C "$VM_CLI_INSTALL_PATH" || {
    __vm_cli__message --failed
    exit 2
  }
  chmod +x "$VM_CLI_INSTALL_PATH/vm-cli"
  __vm_cli__message --done "Updated to $version version."
  exit 0
}
