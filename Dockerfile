# Stage 1: Build the React app
FROM node:18-alpine AS build

WORKDIR /app
COPY app/ ./
RUN npm install
RUN npm run build

# Stage 2: Serve using nginx
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/build /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
