FROM node:22-alpine

RUN apk add --no-cache python3 make g++ libc6-compat
WORKDIR /app

RUN npm i -g pnpm@10.17.1

COPY package.json pnpm-lock.yaml ./

# First install (scripts will be skipped), then approve, then rebuild them
RUN pnpm install --frozen-lockfile || true \
 && pnpm approve-builds -y esbuild sharp @swc/core core-js-pure \
 && pnpm rebuild -r

COPY . .
RUN pnpm build

EXPOSE 1337
CMD ["pnpm","start"]
