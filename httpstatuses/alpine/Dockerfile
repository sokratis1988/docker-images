#FROM node:current-alpine
FROM node:18.18.2-alpine

LABEL org.opencontainers.image.authors="Sokratis Ioannidis"
LABEL version="0.1"
LABEL description="Docker image with httpstatuses from Jon Kulton"
LABEL src=https://github.com/sokratis1988/docker-images

#ENV
ARG VERSION=2.1.0
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Upgrade OS
RUN apk add -U -q --no-cache unzip curl wget gettext
RUN apk upgrade

# Install httpstatuses
RUN wget --quiet https://github.com/httpstatuses/httpstatuses/archive/refs/tags/v$VERSION.zip 
RUN unzip v$VERSION.zip
RUN rm -r v$VERSION.zip

WORKDIR /httpstatuses-$VERSION
RUN npm install

#RUN apk remove

EXPOSE 8080

CMD ["npm", "start"]