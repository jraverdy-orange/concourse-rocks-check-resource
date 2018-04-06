FROM alpine:edge
RUN  apk add --update perl perl-canary-stability perl-json curl
COPY /assets /opt/resource
