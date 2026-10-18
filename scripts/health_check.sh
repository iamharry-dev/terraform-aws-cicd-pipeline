#!/usr/bin/env bash
# Post-deployment health check.
set -euo pipefail

APP_URL="${APP_URL:-http://localhost:8000}"
RETRIES="${RETRIES:-10}"
SLEEP="${SLEEP:-5}"

for i in $(seq 1 "${RETRIES}"); do
  if curl -fsS "${APP_URL}/health" >/dev/null 2>&1; then
    echo "Service healthy on attempt ${i}."
    exit 0
  fi
  echo "Attempt ${i}/${RETRIES} failed; retrying in ${SLEEP}s..."
  sleep "${SLEEP}"
done

echo "Health check failed."
exit 1
