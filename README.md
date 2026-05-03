# mem0-dashboard

Builds and publishes a self-hosted Mem0 dashboard container image to GHCR.

This repository isolates image build and release automation from deployment repositories.

## Source of truth

- Upstream project: `mem0ai/mem0`
- Dashboard path: `server/dashboard`
- Pinned upstream tag: `ARG MEM0_VERSION` in `Dockerfile` (currently `v2.0.1`)

The Docker build downloads the upstream source archive for that tag and builds the
dashboard app from `server/dashboard`.

## Workflow model

Canonical workflows are synced from `jr200-labs/github-action-templates` via:

- `scripts/sync-shared`
- `scripts/sync-shared-drift-check`

Workflow groups configured in `.github/.shared-config.yaml`:

- `hygiene`
- `docker`
- `release`

Release flow:

1. Conventional commits merge to `master`
2. `release-please.yaml` opens/updates a Release PR
3. Merging the Release PR creates tag + GitHub Release
4. `build-docker-image.yaml` publishes the GHCR image from that tag

## Renovate

`renovate.json` includes a regex manager that tracks:

- `ARG MEM0_VERSION=...`

Datasource: `github-tags` for `mem0ai/mem0`.

This keeps upstream tag updates as explicit PRs while preserving pinned, reproducible builds.

## Runtime env vars

- `NEXT_PUBLIC_API_URL` (required)
- `NEXT_PUBLIC_INSTANCE_NAME` (optional)

The image preserves upstream runtime env replacement via `entrypoint.sh`.
