# dockerhub-mailjet
[![](https://images.microbadger.com/badges/image/fedorage/mailjet.svg)](https://microbadger.com/images/fedorage/mailjet "Get your own image badge on microbadger.com")

This is a SMTP docker container for sending emails with MAILJET.

# Features
Quick integration of Mailjet Mailing services into your Docker / Docker-compose projects by opening an SMTP server on port 25 ready for production.

# How to Use
Go to your MAILJET Dashboard (https://www.mailjet.com/account/setup) to extract your USER KEY and API KEY for using Mailjet.

This container will automatically install the depedencies required for exim4 and configure it for mailjet (in /etc/exim4/ directory) on launch.

# Environment variables
 * *RELAY_NETWORK_RANGES*: MUST start with : e.g :192.168.0.0/24 or :192.168.0.0/24:10.0.0.0/16 if you want to force the network (see exim4 *dc_relay_nets*). By default (""), container network is set.
 * *RELAY_DOMAINS*: domains to relay (see exim4 *dc_relay_domains*)
 * *SMARTHOST_ALIASES*: Aliases allowed for relayin
 * *SMARTHOST_ADDRESS*: Mailjet SMTP Server (Should not be changed)
 * *SMARTHOST_PORT*: Mailjet Port Number (Should not be changed)
 * *SMARTHOST_USER*: Your User API KEY
 * *SMARTHOST_PASSWORD*: Your PASSWORD API KEY

# Port
* 25: Exim4 SMTP daemon

# Setup 
## Example values for Simple Relay on current Docker network
Here are the values for environment variables to set for a minimal working mailjet configuration
~~~~
RELAY_NETWORK_RANGES="" (Use the default "" with docker-compose for the default subnetwork)
RELAY_DOMAINS="" (Use the default "" if you don't need to for the relay domain list) 
SMARTHOST_ALIASES="*" (Use the default "*" to allow the SMTP relay to forward any mail)
SMARTHOST_ADDRESS="in.mailjet.com"
SMARTHOST_PORT="587"
SMARTHOST_USER="<USERKEYKEY>"
SMARTHOST_PASSWORD="<APIKEY>"
~~~~

## docker example
Example to enable any client IP to send emails (see network range)
~~~~
docker run -d --name mailer \
       -e RELAY_NETWORKS_RANGE=":0.0.0.0/0" \
       -e RELAY_DOMAINS="" \
       -e SMARTHOST_ALIASES="*" \
       -e SMARTHOST_ADDRESS="in.mailjet.com" \
       -e SMARTHOST_PORT="587" \
       -e SMARTHOST_USER="<YOURAPIKEY>" \
       -e SMARTHOST_PASSWORD="<YOURAPIPASSWORD>" \
      fedorage/mailjet:latest
~~~~

## docker-compose example (version 2)
~~~~
version: '2'

services:
  mailer:
    image: fedorage/mailjet:latest
    ports:
     - "25:25"
    environment:
      RELAY_NETWORK_RANGES: ""
      RELAY_DOMAINS: ""
      SMARTHOST_ALIASES: "*"
      SMARTHOST_ADDRESS: "in.mailjet.com"
      SMARTHOST_USER: "<YOURAPIKEY>"
      SMARTHOST_PASSWORD: "<YOURAPIPASSWORD>"
~~~~

# Manually test your SMTP
with your netcat command line, example: nc 172.42.0.1 25
~~~~
HELO MOTO
MAIL FROM:<webmestre@exvoto.org>
RCPT TO:<fedorage@mail.com>
DATA
Date: Thu, 21 May 2016 05:33:29 -0700
From: WEBMESTRE <webmestre@exvoto.org>
Subject: The Next Meeting
To: fedorage@mail.com
Hi John, The next meeting will be on Friday.
.
~~~~

# Thanks
Based on Namshi repository sources https://github.com/namshi/docker-smtp

