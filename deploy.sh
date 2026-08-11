#!/usr/bin/env bash
set -euo pipefail


SERVICE="web"
COMPOSE="docker compose"
HEALTH_URL="http://localhost:${HOST_PORT:-5000}/health"
MAX_WAIT=30

if [ ! -f .env ]; then
  echo "ERROR: .env not found. Copy .env.example to .env first." >&2
  exit 1
fi

echo "==> Building new image..."
$COMPOSE build "$SERVICE"

echo "==> Starting new container (compose will replace the old one)..."
$COMPOSE up -d --no-deps --force-recreate "$SERVICE"

echo "==> Waiting for /health to return 200 (timeout ${MAX_WAIT}s)..."
elapsed=0
until curl -sf -o /dev/null -w "%{http_code}" "$HEALTH_URL" | grep -q "200"; do
  sleep 2
  elapsed=$((elapsed + 2))
  if [ "$elapsed" -ge "$MAX_WAIT" ]; then
    echo "ERROR: service did not become healthy in time. Rolling back logs below:" >&2
    $COMPOSE logs --tail=50 "$SERVICE"
    exit 1
  fi
done

echo "==> Deployment successful. Service is healthy."
$COMPOSE ps
