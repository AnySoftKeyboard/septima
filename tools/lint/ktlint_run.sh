#!/usr/bin/env bash
# tools/lint/ktlint_run.sh

# Find the ktlint jar
# 1. From --ruleset flag if provided by aspect
JAR=""
args=()
for arg in "$@"; do
  if [[ "$arg" == --ruleset=* ]]; then
    JAR="${arg#--ruleset=}"
    continue
  fi
  args+=("$arg")
done

# 2. Hardcoded sandbox path
if [[ ! -f "$JAR" ]]; then
  JAR=$(find . -name "downloaded.jar" | grep ktlint_jar | head -n 1)
fi

# 3. Another sandbox path
if [[ ! -f "$JAR" ]]; then
  JAR=$(find . -name "ktlint" | grep com_github_pinterest_ktlint | head -n 1)
fi

if [[ ! -f "$JAR" ]]; then
  echo >&2 "ERROR: ktlint jar not found"
  exit 1
fi

exec java -jar "$JAR" "${args[@]}"
