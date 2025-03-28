# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/15 16:47:55 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/20 20:49:09 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk add --no-cache \
    php82 \
    php82-session \
	php82-mysqli \
    && rm -rf /var/cache/apk/*

RUN addgroup -S www-data || true && adduser -S www-data -G www-data || true

WORKDIR /var/www/html

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O index.php

RUN chown -R www-data:www-data /var/www/html/

EXPOSE 9001
CMD ["php82", "-S", "[::]:9001", "-t", "/var/www/html"]
