#!/bin/bash
set -e

echo "🐳 Pulling latest image..."
docker pull balaarasan/dev-final:latest || true

echo "🚀 Deploying container..."
docker compose down
docker compose up -d

echo "🎉 Deployment complete!"
