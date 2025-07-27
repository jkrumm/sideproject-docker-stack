FROM oven/bun

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/jkrumm/bun-email-api.git

WORKDIR /usr/src/app/bun-email-api

ENV NODE_ENV=production

RUN bun install --production

RUN bun build \
	--compile \
	--minify-whitespace \
	--minify-syntax \
	--target bun \
	--outfile server \
	./src/index.ts

CMD ["./server"]

EXPOSE 3010