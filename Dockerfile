# --- builder stage ---
FROM node:22-alpine AS builder
WORKDIR /app

# add a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# copy package files first for layer caching
COPY package.json package-lock.json* .

# install dependencies (CI-friendly) : Installs exactly what’s in package-lock.json (no updates).
RUN npm ci --production=false

# copy app sources
COPY . .

# build step placeholder (if you had a build step, e.g. for TS)
# RUN npm run build

# --- final image ---
FROM node:22-alpine
WORKDIR     /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# copy only production dependencies from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./server.js
COPY --from=builder /app/package.json ./package.json

# set non-root user
USER appuser

EXPOSE 3000
ENV NODE_ENV=production
CMD ["node" , "server.js"]
