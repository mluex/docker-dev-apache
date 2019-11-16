FROM debian:stretch

ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $HTTPD_PREFIX/bin:$PATH
RUN mkdir -p "$HTTPD_PREFIX" \
    && chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apache2 curl openssl git \
    && rm -r /var/lib/apt/lists/*
RUN a2enmod proxy_fcgi ssl rewrite proxy proxy_balancer proxy_http proxy_ajp
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-dev-local.key -out /etc/ssl/certs/ssl-cert-dev-local.pem -subj "/C=DE/ST=North Rhine-Westphalia/L=Cologne/O=Security/OU=Development/CN=dev.local"
RUN sed -i '/Global configuration/a \
ServerName dev.local \
' /etc/apache2/apache2.conf
EXPOSE 80 443
RUN rm -f /run/apache2/apache2.pid
CMD apachectl  -DFOREGROUND -e info