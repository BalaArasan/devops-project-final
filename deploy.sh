#!/bin/bash
set -e

IMAGE=$1

echo "🚀 Pulling production image..."
docker pull $IMAGE

echo "🛑 Stopping old container..."
docker stop final-app || true
docker rm final-app || true

echo "🚀 Running new container..."
docker run -d --name final-app -p 80:80 $IMAGE

echo "✅ Deployment complete!"
