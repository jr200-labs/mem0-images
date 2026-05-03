# mem0-images

Builds and publishes self-hosted Mem0 container images to GHCR.

This repository isolates image build and release automation from deployment repositories.

## Images

| Image | Dockerfile | Purpose |
|---|---|---|
| `mem0-dashboard` | upstream `server/dashboard/Dockerfile` | Mem0 Next.js dashboard UI |
| `mem0-api-server` | upstream `server/Dockerfile` | Mem0 FastAPI self-hosted server |

## Source of truth

- Upstream project: `mem0ai/mem0`
- Server path: `server`
- Dashboard path: `server/dashboard`
- Pinned upstream tag: `.github/images.yaml` git context tag (currently `v2.0.1`)

Each Docker build uses upstream Git context directly so the Dockerfiles stay identical
to official Mem0 sources at the pinned tag.

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
4. `build-docker-image.yaml` publishes all declared images from that tag

## Renovate

`renovate.json` includes a regex manager that tracks the pinned upstream mem0 tag in
`.github/images.yaml`.

Datasource: `github-tags` for `mem0ai/mem0`.

This keeps upstream tag updates as explicit PRs while preserving pinned, reproducible builds.

## Runtime env vars

`mem0-dashboard`:

- `NEXT_PUBLIC_API_URL` (required)
- `NEXT_PUBLIC_INSTANCE_NAME` (optional)

The dashboard image preserves upstream runtime env replacement via `entrypoint.sh`.

`mem0-api-server`:

- Runtime configuration is provided via environment variables from deployment config.
- Startup command can be overridden by deploy-time values (for example, DB migrations + server boot).
