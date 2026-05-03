#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

api_dockerfile="$repo_root/images/mem0-api-server/Dockerfile"
dashboard_dockerfile="$repo_root/images/mem0-dashboard/Dockerfile"

for f in "$api_dockerfile" "$dashboard_dockerfile"; do
  if [ ! -f "$f" ]; then
    echo "missing file: $f" >&2
    exit 1
  fi
done

extract_version() {
  local file="$1"
  awk -F= '/^ARG MEM0_VERSION=/{print $2; exit}' "$file"
}

api_version="$(extract_version "$api_dockerfile")"
dashboard_version="$(extract_version "$dashboard_dockerfile")"

if [ -z "$api_version" ] || [ -z "$dashboard_version" ]; then
  echo "failed to parse MEM0_VERSION from Dockerfiles" >&2
  exit 1
fi

if [ "$api_version" != "$dashboard_version" ]; then
  echo "MEM0_VERSION mismatch between Dockerfiles: api=$api_version dashboard=$dashboard_version" >&2
  exit 1
fi

version="$api_version"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

upstream_api="$tmp_dir/upstream-server.Dockerfile"
upstream_dashboard="$tmp_dir/upstream-dashboard.Dockerfile"

curl -fsSL "https://raw.githubusercontent.com/mem0ai/mem0/${version}/server/Dockerfile" -o "$upstream_api"
curl -fsSL "https://raw.githubusercontent.com/mem0ai/mem0/${version}/server/dashboard/Dockerfile" -o "$upstream_dashboard"

echo "Comparing mem0-api-server Dockerfile against upstream ${version}"
if ! diff -u "$upstream_api" "$api_dockerfile"; then
  echo "mem0-api-server Dockerfile differs from upstream" >&2
  exit 1
fi

echo "Comparing mem0-dashboard Dockerfile against upstream ${version}"
if ! diff -u "$upstream_dashboard" "$dashboard_dockerfile"; then
  echo "mem0-dashboard Dockerfile differs from upstream" >&2
  exit 1
fi

echo "Dockerfiles match upstream mem0 ${version}."
