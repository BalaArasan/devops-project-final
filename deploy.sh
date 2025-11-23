#!/bin/bash
set -e

IMAGE=$1

echo "Deploying image: $IMAGE"

docker pull $IMAGE
docker stop final-app || true
docker rm final-app || true
docker run -d --name final-app -p 80:80 $IMAGE
