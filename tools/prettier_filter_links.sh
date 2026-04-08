#!/usr/bin/env bash

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

# Run the real prettier binary
if [[ -z ${PRETTIER_BIN} ]]; then
  PRETTIER_BIN="$RUNFILES_DIR/_main/tools/prettier_/prettier"
fi

exec "${PRETTIER_BIN}" "${args[@]}"
