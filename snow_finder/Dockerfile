FROM denoland/deno:2.1.3

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/jkrumm/snow-finder.git

WORKDIR /usr/src/app/snow-finder

ENV NODE_ENV=production

RUN deno install

CMD ["deno", "run", "serve"]

EXPOSE 8000