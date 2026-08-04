FROM ruby:4.0.6-alpine3.23

RUN apk update && \
    apk add \
    build-base \
    yaml-dev \
    tzdata \
    bash \
    sudo \
    git 

ARG UID=1000
ARG GID=1000

# add user
RUN addgroup -g $GID docker && \
    adduser -S -u $UID -G docker docker && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo 'docker:docker' | chpasswd

USER docker