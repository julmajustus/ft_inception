# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/15 21:38:54 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/18 21:15:13 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.20

RUN apk update && apk add --no-cache python3

COPY site/index.html /site/index.html

WORKDIR /site

EXPOSE 9002
CMD ["python3", "-m", "http.server", "9002"]
