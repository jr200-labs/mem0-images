# mem0-dashboard

Builds and publishes a self-hosted Mem0 dashboard container image to GHCR.

## Source of truth

- Upstream project: `mem0ai/mem0`
- Dashboard path: `server/dashboard`
- Pinned upstream commit: `6d3486ca5671f431b00450ab191e7380901b55b8`

## Runtime env vars

- `NEXT_PUBLIC_API_URL` (required)
- `NEXT_PUBLIC_INSTANCE_NAME` (optional)

The image preserves upstream runtime env replacement via `entrypoint.sh`.
