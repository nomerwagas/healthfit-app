# ════════════════════════════════════════════════════════════════
# Dockerfile — HealthFit Flutter Web App
# Stage 1: Build Flutter Web
# Stage 2: Serve with nginx
# ════════════════════════════════════════════════════════════════

# ── Stage 1: Build ───────────────────────────────────────────────────────────
# Use debian:bookworm (stable) instead of debian:latest
# debian:latest changed to trixie which doesn't have openjdk-17-jdk
FROM debian:bookworm-slim AS build-env

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
ENV FLUTTER_VERSION=3.41.2
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && cd /flutter \
    && git checkout $FLUTTER_VERSION

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-cache Flutter web tools
RUN flutter precache --web

# Set workdir and copy project
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build Flutter web with injected API keys via --dart-define
ARG WEATHER_API_KEY
ARG FIREBASE_API_KEY
ARG FIREBASE_AUTH_DOMAIN
ARG FIREBASE_PROJECT_ID
ARG FIREBASE_STORAGE_BUCKET
ARG FIREBASE_MESSAGING_SENDER_ID
ARG FIREBASE_APP_ID

RUN flutter build web --release \
    --dart-define=WEATHER_API_KEY=${WEATHER_API_KEY} \
    --dart-define=FIREBASE_API_KEY=${FIREBASE_API_KEY} \
    --dart-define=FIREBASE_AUTH_DOMAIN=${FIREBASE_AUTH_DOMAIN} \
    --dart-define=FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID} \
    --dart-define=FIREBASE_STORAGE_BUCKET=${FIREBASE_STORAGE_BUCKET} \
    --dart-define=FIREBASE_MESSAGING_SENDER_ID=${FIREBASE_MESSAGING_SENDER_ID} \
    --dart-define=FIREBASE_APP_ID=${FIREBASE_APP_ID}

# ── Stage 2: Serve ───────────────────────────────────────────────────────────
FROM nginx:alpine

# Copy built web files to nginx html directory
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx config for Flutter web (handles routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]