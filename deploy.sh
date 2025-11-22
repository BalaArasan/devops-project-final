#!/bin/bash

PROD_REPO="balaarasan/prod-final"
TAG=$1

if [ -z "$TAG" ]; then
  echo "❌ Usage: ./deploy.sh <image-tag>"
  exit 1
fi

echo "🚀 Pulling production image..."
docker pull $PROD_REPO:$TAG

echo "🛑 Stopping old container..."
docker stop final-app || true
docker rm final-app || true

echo "🚀 Running new container..."
docker run -d --name final-app -p 80:80 $PROD_REPO:$TAG

echo "✅ Deployment complete!"
