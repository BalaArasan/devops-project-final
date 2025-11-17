#!/bin/bash

IMAGE_NAME="bala1224/dev"
TAG="latest"

echo "[BUILD] Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "[BUILD] Pushing image to Docker Hub..."
docker push $IMAGE_NAME:$TAG

echo "[BUILD] Completed."#!/bin/bash
echo "[build] Starting image build..."
docker build -t balaarasan/dev:latest .
