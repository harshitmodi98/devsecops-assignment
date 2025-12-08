# ---------- Stage 1: Build Stage ----------
FROM node:18-slim AS builder

WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm ci --omit=dev && npm cache clean --force

# Copy full project
COPY . .

# ---------- Stage 2: Runtime Stage ----------
FROM node:18-slim AS runtime

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# OS Security Patching for Trivy
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy built application from builder stage
COPY --from=builder /app /app

# Run as non-root user
USER node

EXPOSE 3000

CMD ["node", "src/index.js"]
