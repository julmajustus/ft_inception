#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start-ftp.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/16 00:01:49 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/16 00:01:49 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

set -e

if ! id -u "$FTP_USER" >/dev/null 2>&1; then
  echo "Creating FTP user: $FTP_USER"
  adduser -D "$FTP_USER"
  echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

mkdir -p /var/www/html
chown -R "$FTP_USER:$FTP_USER" /var/www/html
chmod 757 /var/www/html

CONFIG_FILE="/etc/vsftpd/vsftpd.conf"

config_set() {
  key="$1"
  value="$2"
  if grep -q "^${key}=" "$CONFIG_FILE"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$CONFIG_FILE"
  else
    echo "${key}=${value}" >> "$CONFIG_FILE"
  fi
}

for setting in \
  "listen=YES" \
  "listen_address=0.0.0.0" \
  "anonymous_enable=NO" \
  "local_enable=YES" \
  "write_enable=YES" \
  "local_umask=022" \
  "chroot_local_user=YES" \
  "allow_writeable_chroot=YES" \
  "pasv_enable=YES" \
  "pasv_min_port=30000" \
  "pasv_max_port=30009" \
  "pasv_promiscuous=YES" \
  "pasv_address=0.0.0.0" \
  "pasv_addr_resolve=YES" \
  "seccomp_sandbox=NO" \
  "local_root=/var/www/html" \
  "userlist_enable=YES" \
  "userlist_file=/etc/vsftpd.userlist" \
  "userlist_deny=NO"
do
  key=$(echo "$setting" | cut -d'=' -f1)
  value=$(echo "$setting" | cut -d'=' -f2-)
  config_set "$key" "$value"
done

echo "$FTP_USER" | tee -a /etc/vsftpd.userlist &> /dev/null

echo "Starting vsftpd with the following configuration:"
cat "$CONFIG_FILE"

exec /usr/sbin/vsftpd "$CONFIG_FILE"
