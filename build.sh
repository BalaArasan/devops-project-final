#!/bin/bash
set -e

TAG=$(date +%Y%m%d%H%M)

echo "🔧 Building Docker image..."
docker build -t balaarasan/dev-final:$TAG .

echo "🔧 Tagging latest..."
docker tag balaarasan/dev-final:$TAG balaarasan/dev-final:latest

echo "🚀 Pushing to Docker Hub..."
docker push balaarasan/dev-final:$TAG
docker push balaarasan/dev-final:latest

echo "✅ Build complete. Image: balaarasan/dev-final:$TAG"
