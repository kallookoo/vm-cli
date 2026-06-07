#!/usr/bin/env bash

# shellcheck source=/dev/null
source src/shared/environment.bash

TAG_NAME="v$VM_CLI_VERSION"

git show-ref --tags --verify --quiet "refs/tags/$TAG_NAME" || {
  git tag -a "$TAG_NAME" -m "$(git log -1 --format=%s)"
}
