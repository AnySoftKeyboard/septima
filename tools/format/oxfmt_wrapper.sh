#!/usr/bin/env bash
# tools/format/oxfmt_wrapper.sh

# The first argument is the path to the oxfmt binary
OXFMT="$1"
shift

# Filter out node_modules and other unwanted dirs from remaining arguments
args=()
has_check=0
for arg in "$@"; do
  if [[ "$arg" == "--check" ]]; then
    has_check=1
    continue
  fi
  if [[ "$arg" == node_modules/* ]] || [[ "$arg" == bazel-* ]]; then
    continue
  fi
  args+=("$arg")
done

# If no args left (or only --check was present), just exit successfully
if [ ${#args[@]} -eq 0 ]; then
  exit 0
fi

if [ $has_check -eq 1 ]; then
  "$OXFMT" --check "${args[@]}"
else
  "$OXFMT" --write "${args[@]}"
fi
