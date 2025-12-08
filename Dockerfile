# ---------- Stage 1: Build Stage ----------
FROM node:18-slim AS builder

WORKDIR /app

# Copy lockfile + package.json first
COPY package.json package-lock.json ./

# Install all production deps using lockfile (includes overrides)
RUN npm ci --omit=dev && npm cache clean --force

# Copy rest of the app
COPY . .

# ---------- Stage 2: Runtime Stage ----------
FROM node:18-slim AS runtime

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Fully patch Debian for OS CVEs
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy built app + node_modules from builder
COPY --from=builder /app /app

# Run as non-root user
USER node

EXPOSE 3000

CMD ["node", "src/index.js"]
