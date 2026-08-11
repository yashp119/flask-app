#!/usr/bin/env bash
set -uo pipefail

# health-monitor.sh — polls /health every 10 seconds, logs HTTP code + timestamp.
# Run in the foreground, or in the background with:  ./health-monitor.sh &

HEALTH_URL="http://localhost:${HOST_PORT:-5000}/health"
LOG_FILE="health-monitor.log"
INTERVAL=10

echo "Monitoring $HEALTH_URL every ${INTERVAL}s. Logging to $LOG_FILE. Ctrl+C to stop."

while true; do
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  http_code=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL" || echo "000")
  echo "$timestamp - HTTP $http_code" | tee -a "$LOG_FILE"
  sleep "$INTERVAL"
done
