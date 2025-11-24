#!/bin/bash
set -e

IMAGE_NAME="balaarasan12/dev-final"
TAG=$(date +%Y%m%d%H%M)

echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "🏷️ Tagging latest..."
docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:latest

echo "📤 Pushing to Docker Hub..."
docker push $IMAGE_NAME:$TAG
docker push $IMAGE_NAME:latest

echo "✅ Build Completed Successfully!"
echo "Image: $IMAGE_NAME:$TAG"
