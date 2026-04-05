#!/usr/bin/env bash
# tools/format/ktlint_wrapper.sh

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${BAZEL_FREEZE_RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }
f=; set +e
# --- end runfiles.bash initialization v3 ---

# Extract flags and files
files=()
ktlint_args=()
for arg in "$@"; do
  if [[ "$arg" == -* ]]; then
    ktlint_args+=("$arg")
  elif [[ -f "$arg" ]]; then
    files+=("$arg")
  fi
done

if [ ${#files[@]} -eq 0 ]; then
  exit 0
fi

# Find the ktlint jar in our runfiles or sandbox
JAR=$(rlocation "ktlint_jar/jar/downloaded.jar")

if [[ ! -f "$JAR" ]]; then
  # Fallback: search in the current execution tree
  JAR=$(find . -name "downloaded.jar" | grep ktlint_jar | head -n 1)
fi

if [[ ! -f "$JAR" ]]; then
  echo >&2 "ERROR: ktlint jar not found"
  exit 1
fi

# Make sure we are in the workspace root
if [[ -n "$BUILD_WORKSPACE_DIRECTORY" ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
fi

# Run ktlint with format flag
exec java -jar "$JAR" -F "${files[@]}"
