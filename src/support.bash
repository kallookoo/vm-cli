# Build Priority: 0

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Unsupported OS. Only macOS is supported." >&2
  exit 1
fi
