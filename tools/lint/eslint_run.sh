#!/usr/bin/env bash
# tools/lint/eslint_run.sh

# Find eslint binary
ESLINT=$(find . -name "eslint" | grep "eslint_" | head -n 1)

if [[ ! -f "$ESLINT" ]]; then
  ESLINT=$(find . -name "eslint.bash" | head -n 1)
fi

if [[ ! -f "$ESLINT" ]]; then
  echo >&2 "ERROR: eslint binary not found"
  exit 1
fi

# Try to find the workspace root
ROOT="$PWD"
while [[ "$ROOT" != "/" && ! -f "$ROOT/.bazelversion" ]]; do
  ROOT="$(dirname "$ROOT")"
done

if [[ -f "$ROOT/.bazelversion" ]]; then
  cd "$ROOT"
fi

# Set BAZEL_BINDIR for js_binary
export BAZEL_BINDIR=.

# Check if files exist
for arg in "$@"; do
  if [[ "$arg" != -* ]]; then
    if [[ ! -f "$arg" ]]; then
      echo >&2 "DEBUG: File not found: $arg (PWD=$PWD)"
    fi
  fi
done

# Run eslint
exec "$ESLINT" "$@"
