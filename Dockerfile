FROM node:22-alpine

# Native deps for esbuild/sharp/swc on Alpine
RUN apk add --no-cache python3 make g++ libc6-compat

WORKDIR /app
RUN npm i -g pnpm@10.17.1

# Install deps first (scripts will be skipped this first time)
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile || true \
  && pnpm approve-builds esbuild sharp @swc/core core-js-pure \
  && pnpm rebuild -r esbuild sharp @swc/core core-js-pure

# Bring in the rest and build Strapi admin
COPY . .
RUN pnpm build

# Slim runtime
RUN pnpm prune --prod

EXPOSE 1337
ENV NODE_ENV=production
CMD ["pnpm","start"]
