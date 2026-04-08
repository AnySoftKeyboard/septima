#!/usr/bin/env bash
# tools/format/prettier.sh

# Filter out symbolic links from the arguments
args=()
for arg in "$@"; do
  if [[ -L "$arg" ]]; then
    continue
  fi
  args+=("$arg")
done

if [ ${#args[@]} -eq 0 ]; then
  exit 0
fi

# Prettier needs BAZEL_BINDIR=. to correctly resolve paths
export BAZEL_BINDIR=.

# Run the real prettier binary
# We assume it's available in node_modules/.bin/prettier
exec ./node_modules/.bin/prettier "${args[@]}"
