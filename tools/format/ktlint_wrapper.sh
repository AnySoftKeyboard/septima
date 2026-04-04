#!/usr/bin/env bash
# tools/format/ktlint_wrapper.sh

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${BAZEL_FREEZE_RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$0.runfiles/$f")" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }
f=; set +e
# --- end runfiles.bash initialization v3 ---

# Try to find the ktlint jar via rlocation
# We try various possible names for the repository mapping
JAR=$(rlocation "ktlint_jar/jar/downloaded.jar")

if [[ ! -f "$JAR" ]]; then
  JAR=$(rlocation "_main/external/ktlint_jar/jar/downloaded.jar")
fi

if [[ ! -f "$JAR" ]]; then
  # Try to find it in runfiles directory
  JAR=$(find "$0.runfiles" -name "downloaded.jar" | grep ktlint_jar | head -n 1)
fi

if [[ ! -f "$JAR" ]]; then
  echo >&2 "ERROR: ktlint jar not found"
  # find "$0.runfiles" -maxdepth 10
  exit 1
fi

# Filter args - format_multirun might pass things we need to ignore
args=()
for arg in "$@"; do
  # Skip the first arg if it's the one we passed in BUILD.bazel (DUMMY_JAR_PATH)
  if [[ "$arg" == "DUMMY_JAR_PATH" ]]; then
    continue
  fi
  if [[ "$arg" == "--set-exit-if-changed" ]] || [[ "$arg" == "--dry-run" ]]; then
    continue
  fi
  args+=("$arg")
done

if [ ${#args[@]} -eq 0 ]; then
  exit 0
fi

# Make sure we are in the workspace root
if [[ -n "$BUILD_WORKSPACE_DIRECTORY" ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
fi

# Run ktlint
exec java -jar "$JAR" -F "${args[@]}"
