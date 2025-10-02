FROM node:22-alpine

# Install all necessary build dependencies for native packages
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    gcc \
    musl-dev \
    libc6-compat \
    vips-dev \
    pkgconfig \
    autoconf \
    automake \
    libtool \
    nasm

WORKDIR /app

# Set environment variables for native compilation
ENV PYTHON=/usr/bin/python3
ENV MAKE=/usr/bin/make
ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++

RUN npm i -g pnpm@10.17.1

# install with lockfile first for cache
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --ignore-scripts && \
    pnpm rebuild

# copy sources and build
COPY . .
RUN pnpm build

# slim runtime - remove dev dependencies and build tools
RUN pnpm prune --prod && \
    apk del python3 make g++ gcc musl-dev autoconf automake libtool nasm && \
    rm -rf /root/.cache /tmp/* /var/cache/apk/*

EXPOSE 1337
ENV NODE_ENV=production
USER node
CMD ["pnpm","start"]
