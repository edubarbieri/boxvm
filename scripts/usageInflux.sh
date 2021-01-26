#!/bin/bash

source "/etc/profile.d/setvar.sh"

public_ip="$(curl --silent ifconfig.co)"
public_host="$(host $public_ip)"
uptime="$(uptime -p)"

GIT_FILE=/remote_home/.gitconfig
if [ -f "$GIT_FILE" ]; then
  name="$(grep name /remote_home/.gitconfig | awk -F = '{ print $2 }' | xargs)"
  email="$(grep email /remote_home/.gitconfig | awk -F = '{ print $2 }' | xargs)"
fi

curl -s -o /dev/null \
--max-time 20 \
-XPOST 'http://poc-checkout.ddns.net:8086/write?db=vm_renner' \
--data-binary "m_box,ip=\"$public_ip\",user=\"$HOST_USERNAME\",computerName=\"$HOST_COMPUTERNAME\",domain=\"$HOST_USERDOMAIN\" name=\"$name\",email=\"$email\",uptime=\"$uptime\",host=\"$public_host\""