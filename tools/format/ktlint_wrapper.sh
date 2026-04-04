#!/usr/bin/env bash
# tools/format/ktlint_wrapper.sh

# The first argument is the path to the ktlint binary
KTLINT="$1"
shift

# Make KTLINT path absolute before we cd
if [[ "$KTLINT" != /* ]]; then
  KTLINT="$PWD/$KTLINT"
fi

# Filter args
args=()
has_check=0
for arg in "$@"; do
  if [[ "$arg" == "--set-exit-if-changed" ]] || [[ "$arg" == "--dry-run" ]]; then
    has_check=1
    continue
  fi
  if [[ "$arg" == node_modules/* ]] || [[ "$arg" == bazel-* ]]; then
    continue
  fi
  args+=("$arg")
done

if [ ${#args[@]} -eq 0 ]; then
  exit 0
fi

# Try to find the workspace root
ROOT="$PWD"
while [[ "$ROOT" != "/" && ! -f "$ROOT/.bazelversion" ]]; do
  ROOT="$(dirname "$ROOT")"
done

if [[ -f "$ROOT/.bazelversion" ]]; then
  cd "$ROOT"
fi

if [ $has_check -eq 1 ]; then
  exec java -jar "$KTLINT" "${args[@]}"
else
  # Use -F for formatting
  exec java -jar "$KTLINT" -F "${args[@]}"
fi
