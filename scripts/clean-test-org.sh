#!/usr/bin/env bash
# Deletes the repositories that `terraform test` creates in the test org (names test-* and bootstrap),
# so a repository left behind by a failed teardown never blocks the next run.
# Why: on 2026-10-12 the teardown of run "fork" got "409 A conflicting repository operation is still
# in progress" (GitHub was still copying the fork), test-fork stayed, and every later run failed with
# "403 Name already exists on this account".
# Usage: GITHUB_OWNER=codelawcorp-test GH_TOKEN=<token with delete_repo> scripts/clean-test-org.sh
set -euo pipefail

owner="${GITHUB_OWNER:-}"
if [[ "$owner" != "codelawcorp-test" ]]; then
  echo "clean-test-org: refusing to delete repositories of '${owner}': only codelawcorp-test is allowed" >&2
  exit 1
fi

repos=$(gh api --paginate "orgs/${owner}/repos?per_page=100" --jq '.[].name' | grep -E '^(test-.+|bootstrap)$' || true)
if [[ -z "$repos" ]]; then
  echo "clean-test-org: ${owner} has no test repositories left"
  exit 0
fi

for repo in $repos; do
  for attempt in $(seq 1 20); do
    if gh api -X DELETE "repos/${owner}/${repo}" >/dev/null; then
      echo "clean-test-org: deleted ${owner}/${repo}"
      break
    fi
    if [[ $attempt == 20 ]]; then
      echo "clean-test-org: could not delete ${owner}/${repo} after 20 attempts (5 min)" >&2
      exit 1
    fi
    echo "clean-test-org: ${owner}/${repo} not deleted yet (attempt ${attempt}/20), retrying in 15 s"
    sleep 15
  done
done
