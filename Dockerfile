# Use the minimal base Ubuntu image
FROM ubuntu:latest

# Metadata
LABEL maintainer="hostmaster@rafaela.sk" \
      version="1.0" \
      description="Ubuntu with BIND9 DNS and split DNS for lab.rafaela.sk"

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install BIND9
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y bind9 bind9-doc vim && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Directories for zone files
#RUN mkdir -p /etc/bind-dns/zones/private /etc/bind-dns/zones/public

# Copy configuration and zone files
#COPY example.etc.bind/named.conf /etc/bind-dns/named.conf
#COPY example.etc.bind/zones/private/lab.rafaela.sk.zone /etc/bind-dns/zones/private/
#COPY example.etc.bind/zones/public/lab.rafaela.sk.zone /etc/bind-dns/zones/public/

# Expose DNS ports
EXPOSE 53/udp 53/tcp

# Default command
#CMD ["sh", "-c", "test ! -e /etc/bind-dns/named.conf.dyndns && \"${SVR_TYPE}\" == \"master\" && tsig-keygen -a hmac-sha256 dynupdate > /etc/bind-dns/named.conf.dyndns; named -c /etc/bind-dns/named.conf.${SVR_TYPE} -4 -g"]
CMD ["sh", "-c", "test ! -e /etc/bind-dns/named.conf.dyndns && \"${SVR_TYPE}\" == \"master\" && tsig-keygen -a hmac-sha256 dynupdate > /etc/bind-dns/named.conf.dyndns; test ! -e /etc/bind-dns/named.conf.conrols && tsig-keygen -a hmac-sha256 rndc-access-key > /etc/bind-dns/named.conf.controls && echo \"options {\ndefault-server localhost;\ndefault-key rndc-access-key;\n};\n\" > /etc/bind-dns/rndc.conf && cat /etc/bind-dns/named.conf.controls >> /etc/bind-dns/rndc.conf && echo \"\nserver localhost {\n  key  \"rndc-access-key\";\n};\" >> /etc/bind-dns/rndc.conf && echo \"\ncontrols {\n  inet 127.0.0.1 allow { localhost; } keys { rndc-access-key; };\n};\" >> /etc/bind-dns/named.conf.controls; named -c /etc/bind-dns/named.conf.${SVR_TYPE} -4 -g"]

