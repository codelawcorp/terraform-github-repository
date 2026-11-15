#!/usr/bin/env bash
# Automated test of the safety check in clean-test-org.sh: any org other than codelawcorp-test is refused
# before a single GitHub call (gh is replaced by a stub that fails the test if it is called).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
stub="$(mktemp -d)"
trap 'rm -rf "$stub"' EXIT
printf '#!/bin/sh\necho "gh was called: $*" >&2\nexit 99\n' >"$stub/gh"
chmod +x "$stub/gh"

for owner in codelawcorp "" codelawcorp-test-x; do
  set +e
  out=$(PATH="$stub:$PATH" GITHUB_OWNER="$owner" "$here/clean-test-org.sh" 2>&1)
  code=$?
  set -e
  if [[ $code != 1 || "$out" != *"refusing to delete"* ]]; then
    echo "FAIL: owner '$owner' was not refused (exit $code): $out" >&2
    exit 1
  fi
done
echo "PASS: clean-test-org.sh refuses every org but codelawcorp-test"
