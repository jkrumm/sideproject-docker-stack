FROM alpine:latest

COPY ./crontab /etc/crontabs/root

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb-client python3 py3-pip && \
    pip3 install awscli

CMD ["crond", "-f", "-d", "8"]