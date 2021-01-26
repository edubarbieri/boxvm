#!/bin/bash

source "/etc/profile.d/setvar.sh"

generate_post_data()
{
  public_ip="$(curl --silent ifconfig.co)"
  public_host="$(host $public_ip)"
  uptime="$(uptime -p)"

  GIT_FILE=/remote_home/.gitconfig
  if [ -f "$GIT_FILE" ]; then
    name="$(grep name /remote_home/.gitconfig | awk -F = '{ print $2 }' | xargs)"
    email="$(grep email /remote_home/.gitconfig | awk -F = '{ print $2 }' | xargs)"
  fi


  cat <<EOF
{
  "ip": "$public_ip",
  "host": "$public_host",
  "uptime": "$uptime",
  "user": "$HOST_USERNAME",
  "computerName": "$HOST_COMPUTERNAME",
  "domain": "$HOST_USERDOMAIN",
  "name": "$name",
  "email": "$email"
}
EOF
}

curl -s -o /dev/null \
--max-time 20 \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" "http://192.168.113.1:3000/"
