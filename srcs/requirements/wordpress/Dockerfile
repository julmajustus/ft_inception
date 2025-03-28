# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/13 23:59:09 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/27 15:11:06 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk update && apk add --no-cache \
    php82 php82-fpm php82-mysqli php82-curl \
	php82-json php82-openssl php82-mbstring \
	php82-xml wget tar php82-pecl-redis \
	php82-phar php82-cli php82-tokenizer php82-ctype

RUN addgroup -S www-data || true && adduser -S www-data -G www-data || true

RUN mkdir -p /run/php
RUN	mkdir -p /var/www/html 

WORKDIR /tmp
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mv wordpress/* /var/www/html && \
    rm latest.tar.gz

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

RUN cp /usr/bin/php82 /usr/local/bin/php

RUN echo "memory_limit=256M" > /etc/php82/conf.d/memory.ini


COPY ./conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY ./tools/start-wp.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/start-wp.sh

EXPOSE 9000

ENTRYPOINT ["start-wp.sh"]
