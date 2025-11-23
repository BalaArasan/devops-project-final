#!/bin/bash
set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "❌ Usage: ./deploy.sh <image-tag>"
  exit 1
fi

echo "🚀 Pulling production image..."
docker pull $IMAGE

echo "🛑 Stopping old container..."
docker stop final-app || true
docker rm final-app || true

echo "🚀 Running new container..."
docker run -d -p 80:80 --name final-app $IMAGE

echo "✅ Deployment complete!"
