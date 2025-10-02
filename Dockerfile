FROM node:22-alpine

# Native build deps for sharp/esbuild/swc on Alpine
RUN apk add --no-cache python3 make g++ libc6-compat

WORKDIR /app

# 1) Install deps with npm (dev deps included for admin build)
#    Make sure you have a package-lock.json in the repo.
COPY package.json package-lock.json ./
RUN npm ci

# 2) Copy source and build Strapi admin
COPY . .
RUN npm run build

# 3) Optional: slim the image by removing dev deps after build
RUN npm prune --omit=dev

EXPOSE 1337
ENV NODE_ENV=production
CMD ["npm", "start"]
