FROM cgr.dev/chainguard/wolfi-base:latest as builder
ARG BUILD_VERSION="0.1"
ARG TARGETOS
ARG TARGETARCH
ARG HELM_VERSION

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apk upgrade
RUN apk add -U -q --no-cache git curl wget gettext
RUN wget --quiet https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz \
    && tar -xzf helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz \
    && mv ${TARGETOS}-${TARGETARCH}/helm /usr/bin/helm \
    && chmod +x /usr/bin/helm \
    && rm -rf ${TARGETOS}-${TARGETARCH} helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz




FROM cgr.dev/chainguard/wolfi-base:latest
ARG BUILD_VERSION="0.1"

LABEL org.opencontainers.image.authors="Sokratis Ioannidis"
LABEL version=${BUILD_VERSION}
LABEL description="Docker image with helm tools for using in a CI/CD"
LABEL src=https://github.com/sokratis1988/docker-images

#ENV
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install helm
COPY --from=builder /usr/bin/helm /usr/bin/helm
COPY --from=builder /root/.local/share/helm/plugins/helm-push /root/.local/share/helm/plugins/

#RUN helm plugin install https://github.com/chartmuseum/helm-push

# Clean up
RUN apk del --purge curl git wget gettext

ENTRYPOINT [ "helm" ]
CMD ["--help"]