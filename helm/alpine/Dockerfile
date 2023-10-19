FROM alpine:latest

LABEL org.opencontainers.image.authors="Sokratis Ioannidis"
LABEL version="0.1"
LABEL description="Docker image with helm tools for using in a CI/CD"
LABEL src=https://github.com/sokratis1988/docker-images

#ENV
ARG HELM_VERSION=3.13.1
ENV HELM=${HELM_VERSION}
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Upgrade OS
RUN apk add -U -q --no-cache git curl wget gettext
RUN apk upgrade

# Install helm
RUN wget --quiet https://get.helm.sh/helm-v$HELM-linux-amd64.tar.gz
RUN tar -zxvf helm-v$HELM-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/bin/helm && chmod +x /usr/bin/helm
RUN rm -r linux-amd64/ helm-v$HELM-linux-amd64.tar.gz

# Install Plugins
RUN helm plugin install https://github.com/chartmuseum/helm-push

ENTRYPOINT [ "helm" ]
CMD ["--help"]