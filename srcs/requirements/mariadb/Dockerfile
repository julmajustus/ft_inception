# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/13 23:53:08 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/20 20:09:38 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN	mkdir -p /run/mysqld /var/lib/mysql /var/log/mysql/ && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql/ && \
	chmod 755 /var/log/mysql/

EXPOSE 3306

COPY tools/mariadb-start.sh /usr/local/bin

RUN chmod +x /usr/local/bin/mariadb-start.sh

ENTRYPOINT [ "mariadb-start.sh" ]
