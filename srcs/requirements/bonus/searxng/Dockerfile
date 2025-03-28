# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/15 16:48:31 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/20 19:31:22 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20
LABEL maintainer="jmakkone <jmakkone@student.hive.fi>"

RUN apk add --no-cache -t build-dependencies \
    build-base \
    py3-setuptools \
    python3-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    tar \
 && apk add --no-cache \
	git \
    ca-certificates \
    python3 \
    py3-pip \
    libxml2 \
    libxslt \
    openssl \
    tini \
    uwsgi \
    uwsgi-python3 \
    brotli \
 && apk del build-dependencies


WORKDIR /usr/local/searxng

ARG SEARXNG_GID=977
ARG SEARXNG_UID=977
RUN addgroup -g ${SEARXNG_GID} searxng && \
    adduser -u ${SEARXNG_UID} -D -h /usr/local/searxng -s /bin/sh -G searxng searxng

ENV INSTANCE_NAME=searxng \
    AUTOCOMPLETE= \
    BASE_URL= \
    MORTY_KEY= \
    MORTY_URL= \
    SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml \
    UWSGI_SETTINGS_PATH=/etc/searxng/uwsgi.ini \
    UWSGI_WORKERS=%k \
    UWSGI_THREADS=4 \
    SEARXNG_REDIS_PASSWORD=securepw \
    SEARXNG_REDIS_HOST=redis_searxng \
    SEARXNG_REDIS_PORT=6379 \
    SEARXNG_REDIS_DB=0 \
    SEARXNG_BASE_URL=https://${SEARXNG_HOSTNAME:-searxng.example.com}/

RUN git clone https://github.com/searxng/searxng.git /usr/local/searxng

RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

RUN chown -R searxng:searxng searx

RUN su searxng -c "python3 -m compileall -q searx"

EXPOSE 8080

RUN mkdir /etc/searxng/ 

ENTRYPOINT ["/sbin/tini","--","/usr/local/searxng/dockerfiles/docker-entrypoint.sh"]
