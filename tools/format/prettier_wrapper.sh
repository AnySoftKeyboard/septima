#!/usr/bin/env bash
# tools/format/prettier_wrapper.sh

# Filter out symlinks from the arguments
args=()
for arg in "$@"; do
  # If it's a symbolic link, skip it
  if [[ -L "$arg" ]]; then
    continue
  fi
  args+=("$arg")
done

if [ ${#args[@]} -eq 0 ]; then
  exit 0
fi

# Try to find prettier
PRETTIER=""

# 1. Try relative path if we are in the workspace
if [[ -f "./node_modules/.bin/prettier" ]]; then
  PRETTIER="./node_modules/.bin/prettier"
fi

# 2. Try to find it in the current execution tree (silently)
if [[ -z "$PRETTIER" ]]; then
  PRETTIER=$(find . -name "prettier" -type f | grep "node_modules/.bin/prettier" | head -n 1)
fi

if [[ -z "$PRETTIER" ]]; then
  echo >&2 "ERROR: prettier binary not found"
  exit 1
fi

# Make sure we are in the workspace root
if [[ -n "$BUILD_WORKSPACE_DIRECTORY" ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
fi

export BAZEL_BINDIR=.

# Run prettier
exec "$PRETTIER" "${args[@]}"
