# NC Printing Supply billing — production image (Render / any Docker host)
FROM node:20-bookworm-slim

# Chromium for server-side PDF export; Thai fonts as a fallback (documents embed Sarabun)
RUN apt-get update \
 && apt-get install -y --no-install-recommends chromium fonts-thai-tlwg ca-certificates \
 && rm -rf /var/lib/apt/lists/*

ENV CHROMIUM_PATH=/usr/bin/chromium \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
    NEXT_TELEMETRY_DISABLED=1

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

ENV NODE_ENV=production PORT=3000
EXPOSE 3000
# migrate is idempotent; seed only runs when there are no users yet
CMD ["sh", "-c", "npx tsx scripts/migrate.ts && npx tsx scripts/seed.ts && npx next start -p ${PORT}"]
