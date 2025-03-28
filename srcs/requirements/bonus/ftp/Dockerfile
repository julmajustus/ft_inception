# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/15 16:46:16 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/19 09:47:23 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk update && apk add --no-cache vsftpd openssl

COPY ./tools/start-ftp.sh /usr/local/bin/start-ftp.sh

RUN chmod +x /usr/local/bin/start-ftp.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["start-ftp.sh"]
