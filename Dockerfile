FROM node:22-alpine

WORKDIR /app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .

# Strapi build (for admin panel)
RUN pnpm build

EXPOSE 1337
CMD ["pnpm", "start"]