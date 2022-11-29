FROM alpine:latest

ARG HELM_VERSION=3.10.2
ENV HELM=${HELM_VERSION}
LABEL org.opencontainers.image.authors="Sokratis Ioannidis"
LABEL version="0.1"
LABEL description="Docker image with helm tools for using in a CI/CD"
LABEL src=https://github.com/sokratis1988/docker-images
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apk add -U -q --no-cache git
RUN apk upgrade

RUN wget --quiet https://get.helm.sh/helm-v$HELM-linux-arm.tar.gz
RUN tar -zxvf helm-v$HELM-linux-arm.tar.gz
RUN mv linux-arm/helm /usr/local/bin/helm
RUN rm -r linux-arm/ helm-v$HELM-linux-arm.tar.gz

CMD ["/bin/sh"]