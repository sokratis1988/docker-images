ARG IMAGE="python:slim"
ARG BUILD_VERSION="0.1"
FROM ${IMAGE}

LABEL org.opencontainers.image.authors="Sokratis Ioannidis"
LABEL version=${BUILD_VERSION}
LABEL description="Docker image with ansible for using in a CI/CD"
LABEL src=https://github.com/sokratis1988/docker-images

#ENV
ARG ANSIBLE_VERSION
ENV ANSIBLE=${ANSIBLE_VERSION}
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install dependencies and upgrade OS
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ssh \
        openssh-client && \
    pip install --upgrade pip cffi && \
    pip install ansible==${ANSIBLE} && \
    apt-get remove -y --purge --auto-remove gcc libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/.cache

# Check version
RUN ansible --version

# Set working directory
WORKDIR /ansible

# Standardmäßig ausgeführter Befehl, wenn der Container gestartet wird
CMD [ "ansible-playbook", "--version" ]