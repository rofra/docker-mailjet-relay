FROM debian:jessie

MAINTAINER Rodolphe Franceschi "rodolphe.franceschi@gmail.com"

ENV RELAY_NETWORK_RANGES="" \
    RELAY_DOMAINS="" \
    SMARTHOST_ALIASES="*" \
    SMARTHOST_ADDRESS="in-v3.mailjet.com" \
    SMARTHOST_PORT="587" \
    SMARTHOST_USER="DEFAULTAPIKEY" \
    SMARTHOST_PASSWORD="DEFAULTAPIPASS"

RUN apt-get update && \
    apt-get install -y exim4-daemon-light && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

COPY entrypoint.sh /bin/
COPY set-exim4-update-conf /bin/

RUN echo "log_file_path = /etc/stdout" >> /etc/exim4/conf.d/main/02_exim4-config_options

RUN chmod a+x /bin/entrypoint.sh && \
    chmod a+x /bin/set-exim4-update-conf

EXPOSE 25
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["exim", "-bd", "-q15m", "-v"]
