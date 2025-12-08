# ---------- Stage 1: Build Stage ----------
# Using minimal Alpine image for smaller attack surface
FROM node:18-alpine AS builder

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm install --only=production

# Copy application code
COPY . .

# ---------- Stage 2: Runtime Stage ----------
# Use a small Debian slim runtime and upgrade libc6 to pick up security patches
FROM node:18-slim AS runtime

# make apt non-interactive
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Update apt and upgrade libc6 (glibc) to the latest patched version available in distro
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get install -y --no-install-recommends libc6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy built app from builder stage
COPY --from=builder /app /app

# Use non-root user (node user exists in official node images)
USER node

# Expose application port
EXPOSE 3000

# Run the application (match your package.json / src)
CMD ["src/index.js"]
