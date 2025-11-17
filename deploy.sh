#!/bin/bash

echo "[DEPLOY] Starting container..."
docker rm -f devops-react-app 2>/dev/null

docker run -d \
  -p 3000:80 \
  --name devops-react-app \
  bala1224/dev:latest

echo "[DEPLOY] Application deployed successfully!"
#!/bin/bash
echo "[deploy] Starting container..."
docker compose up -d
