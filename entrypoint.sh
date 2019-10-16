#!/bin/bash
set -e

echo 'MAIN_TLS_ENABLE=1' > /etc/exim4/exim4.conf.localmacros

if [ "$MAILNAME" ]; then
	echo "MAIN_HARDCODE_PRIMARY_HOSTNAME = $MAILNAME" > /etc/exim4/exim4.conf.localmacros
	echo $MAILNAME > /etc/mailname
fi

if [ "$KEY_PATH" -a "$CERTIFICATE_PATH" ]; then
	echo "MAIN_TLS_ENABLE=1" >>  /etc/exim4/exim4.conf.localmacros
	cp $KEY_PATH /etc/exim4/exim.key
	cp $CERTIFICATE_PATH /etc/exim4/exim.crt
	chgrp Debian-exim /etc/exim4/exim.key
	chgrp Debian-exim /etc/exim4/exim.crt
	chmod 640 /etc/exim4/exim.key
	chmod 640 /etc/exim4/exim.crt
fi

opts=(
    dc_eximconfig_configtype 'smarthost'
	dc_other_hostnames ''
	dc_local_interfaces "[0.0.0.0]:${PORT:-25} ; [::0]:${PORT:-25}"
    dc_readhost 'receiver'
    dc_relay_domains "${RELAY_DOMAINS}"
    dc_minimaldns 'false'
	dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }')${RELAY_NETWORK_RANGES}"
    dc_smarthost "${SMARTHOST_ADDRESS}::${SMARTHOST_PORT}"
    CFILEMODE '644'
    dc_use_split_config 'false'
    dc_hide_mailname 'true'
    dc_mailname_in_oh 'true'
    dc_localdelivery 'mail_spool'
)

rm -f /etc/exim4/passwd.client
echo "$SMARTHOST_ALIASES;" | while read -d ";" alias; do
  echo "${alias}:$SMARTHOST_USER:$SMARTHOST_PASSWORD" >> /etc/exim4/passwd.client
done

/bin/set-exim4-update-conf "${opts[@]}"

exec "$@"
