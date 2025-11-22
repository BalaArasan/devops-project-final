#!/bin/bash

# Variables
IMAGE_NAME="devops-final-app"
DEV_REPO="balaarasan/dev-final"
TAG=$(date +%Y%m%d%H%M)

echo "🔧 Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "🔧 Tagging image..."
docker tag $IMAGE_NAME:$TAG $DEV_REPO:$TAG

echo "🚀 Pushing to Docker Hub DEV repo..."
docker push $DEV_REPO:$TAG

echo "✅ Build complete. Dev image: $DEV_REPO:$TAG"
