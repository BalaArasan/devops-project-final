#!/bin/bash
set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "❌ ERROR: No image name passed!"
  exit 1
fi

echo "🚀 Pulling image..."
docker pull $IMAGE

echo "🛑 Stopping old container..."
docker stop devops-app || true
docker rm devops-app || true

echo "🚀 Running new container..."
docker run -d -p 80:80 --name devops-app $IMAGE

echo "✅ Deployment complete!"
