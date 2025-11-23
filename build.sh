#!/bin/bash
set -e

TAG=$(date +%Y%m%d%H%M)

echo "🔧 Building Docker image..."
docker build -t balaarasan12/dev-final:$TAG .

echo "🔧 Tagging image..."
docker tag balaarasan12/dev-final:$TAG balaarasan12/dev-final:latest

echo "🚀 Pushing to Docker Hub..."
docker push balaarasan12/dev-final:$TAG
docker push balaarasan12/dev-final:latest

echo "✅ Build complete. Image: balaarasan12/dev-final:$TAG"
