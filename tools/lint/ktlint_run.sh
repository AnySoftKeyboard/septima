#!/usr/bin/env bash
# tools/lint/ktlint_run.sh

# The aspect passes the jar via --ruleset if we use ruleset_jar attribute
# We use this to find the jar in the sandbox
JAR=""
args=()
for arg in "$@"; do
  if [[ "$arg" == --ruleset=* ]]; then
    JAR="${arg#--ruleset=}"
    # Don't pass --ruleset to ktlint if it's the main jar!
    continue
  fi
  args+=("$arg")
done

if [[ ! -f "$JAR" ]]; then
  # Fallback: search for it
  JAR=$(find . -name "downloaded.jar" | grep ktlint_jar | head -n 1)
fi

if [[ ! -f "$JAR" ]]; then
  echo >&2 "ERROR: ktlint jar not found"
  exit 1
fi

exec java -jar "$JAR" "${args[@]}"
