# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/13 23:57:30 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/20 20:13:24 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /run/nginx && \
    mkdir -p /var/www/html && \
    chown -R nginx:nginx /var/www/html/

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 443

COPY ./tools/start-nginx.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-nginx.sh

ENTRYPOINT ["start-nginx.sh"]
