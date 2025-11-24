#!/bin/bash
set -e

IMAGE="balaarasan12/dev-final:latest"
CONTAINER="devops-app"

echo "📥 Pulling latest image..."
docker pull $IMAGE

echo "🛑 Stopping old container (if exists)..."
docker stop $CONTAINER || true
docker rm $CONTAINER || true

echo "🚀 Starting new container..."
docker run -d \
  --name $CONTAINER \
  -p 80:80 \
  $IMAGE

echo "✅ Deployment successful!"
docker ps
