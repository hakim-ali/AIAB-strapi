FROM node:22-alpine

# Native deps for esbuild/sharp/swc on Alpine
RUN apk add --no-cache python3 make g++ libc6-compat

WORKDIR /app

# Use a stable pnpm (matches your logs)
RUN npm i -g pnpm@10.17.1

# Copy manifests first for better layer caching
COPY package.json pnpm-lock.yaml ./

# Create pnpm allowlist so install scripts for these packages can run in CI
# (avoids interactive `pnpm approve-builds`)
RUN printf '{\n  "allowedPackages": {\n    "@swc/core": true,\n    "esbuild": true,\n    "sharp": true,\n    "core-js-pure": true\n  }\n}\n' > .pnpm-allow-scripts

# Install deps (dev deps included so admin build succeeds)
RUN pnpm install --frozen-lockfile

# Bring in the rest of the source and build Strapi admin
COPY . .
RUN pnpm build

# Slim runtime: keep only production deps
RUN pnpm prune --prod

EXPOSE 1337
ENV NODE_ENV=production
CMD ["pnpm", "start"]
