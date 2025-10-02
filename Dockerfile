FROM node:22-alpine

# native deps for esbuild/sharp/swc on Alpine
RUN apk add --no-cache python3 make g++ libc6-compat

WORKDIR /app
RUN npm i -g pnpm@10.17.1

# install with lockfile first for cache
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# copy sources and build
COPY . .
RUN pnpm build

# slim runtime
RUN pnpm prune --prod

EXPOSE 1337
ENV NODE_ENV=production
CMD ["pnpm","start"]
