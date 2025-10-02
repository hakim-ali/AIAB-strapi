# Base
FROM node:22-alpine

# 1) Toolchain & compat libs for native/binary deps (sharp, swc, esbuild)
RUN apk add --no-cache python3 make g++ libc6-compat

WORKDIR /app

# 2) Stable pnpm + enable pre/post scripts non-interactively for CI
ENV PNPM_ENABLE_PRE_POST_SCRIPTS=1
RUN npm i -g pnpm@10.17.1

# 3) Install with lockfile (keep dev deps for Strapi admin build!)
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# 4) Copy source and build admin
COPY . .
RUN pnpm build

# 5) Runtime
EXPOSE 1337
CMD ["pnpm", "start"]
