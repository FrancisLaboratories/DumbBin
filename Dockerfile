# Stage 1: Build the application
FROM node:24-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install && \
    npm cache clean --force

# Copy application files
COPY . .

# Stage 2: Create the runtime image
FROM node:24-alpine

WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copy entrypoint script
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

# Copy only the necessary files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/scripts ./scripts

# Create data directory
RUN mkdir -p data

# Expose port (internal port)
EXPOSE 3000

# Run entrypoint as root to fix permissions, then switch to nodejs
ENTRYPOINT ["./entrypoint.sh"]
