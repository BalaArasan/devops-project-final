#!/bin/bash
set -e

TAG=$(date +%Y%m%d%H%M)

echo "🔧 Building Docker image..."
docker build -t devops-final-app:$TAG .

echo "🔧 Tagging for Docker Hub..."
docker tag devops-final-app:$TAG balaarasan/dev-final:$TAG

echo "📤 Pushing to Docker Hub..."
docker push balaarasan/dev-final:$TAG

echo "✅ Build complete. Image: balaarasan/dev-final:$TAG"
