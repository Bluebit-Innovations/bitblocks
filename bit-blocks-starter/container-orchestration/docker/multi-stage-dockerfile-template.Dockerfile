# ----------------------
# 1. Build stage
# ----------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Install deps (better caching by separating package files)
COPY package*.json ./
RUN npm ci --only=production

# Copy source
COPY . .

# Build (if applicable)
RUN npm run build

# ----------------------
# 2. Runtime stage
# ----------------------
FROM node:20-alpine

WORKDIR /app

# Copy only built files and node_modules from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

EXPOSE 3000

# Run as non-root for security
USER node

CMD ["node", "dist/index.js"]
