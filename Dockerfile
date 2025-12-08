# ---------- Stage 1: Build Stage ----------
# Using minimal Alpine image for smaller attack surface
FROM node:18-alpine AS builder

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy application code
COPY . .

# ---------- Stage 2: Runtime Stage ----------
# Using distroless image for better security
FROM gcr.io/distroless/nodejs18-debian11

# Set working directory
WORKDIR /app

# Copy built app from builder stage
COPY --from=builder /app /app

# Use non-root user for security
USER nonroot

# Expose application port
EXPOSE 3000

# Run the application
CMD ["server.js"]
