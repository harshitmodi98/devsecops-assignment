# ---------- Stage 1: Build Stage ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

# Install only production deps
RUN npm ci --only=production

COPY . .

# ---------- Stage 2: Runtime Stage ----------
FROM node:18-slim AS runtime

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Fully update Debian (fixes libgnutls + perl-base CVEs)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy built files
COPY --from=builder /app /app

# Use secure non-root user
USER node

EXPOSE 3000

CMD ["node", "src/index.js"]
