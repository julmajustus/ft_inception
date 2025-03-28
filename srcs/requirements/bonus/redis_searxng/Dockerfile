# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/15 16:45:47 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/20 15:50:36 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk update && apk add --no-cache redis

EXPOSE 6379

COPY ./tools/start-redis.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-redis.sh

ENTRYPOINT ["start-redis.sh"]
