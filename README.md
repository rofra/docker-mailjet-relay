# dockerhub-mailjet
[![](https://images.microbadger.com/badges/image/debian.svg)](https://microbadger.com/images/debian "Get your own image badge on microbadger.com")

This is a SMTP docker container for sending emails with MAILJET.
# Features
Quick integration of Mailjet Mailing services into your Docker / Docker-compose projects by opening an SMTP server on port 25 ready for production.

# How to Use
Go to your MAILJET Dashboard (https://www.mailjet.com/account/setup) to extract your USER KEY and API KEY for using Mailjet.

This container will automatically install the depedencies required for exim4 and configure it for mailjet (in /etc/exim4/ directory) on launch.

# Environment variables
 * *RELAY_NETWORKS*: MUST start with : e.g :192.168.0.0/24 or :192.168.0.0/24:10.0.0.0/16 if you want to force the network (see exim4 *dc_relay_nets*). By default (""), container network is set.
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
RELAY_NETWORKS=""
RELAY_DOMAINS=""`
SMARTHOST_ALIASES="*"
SMARTHOST_ADDRESS="in.mailjet.com"
SMARTHOST_PORT="587"
SMARTHOST_USER="<USERKEYKEY>"
SMARTHOST_PASSWORD="<APIKEY>"
~~~~

## docker "run" example

# Tribute
Based on Namshi repository sources https://github.com/namshi/docker-smtp

