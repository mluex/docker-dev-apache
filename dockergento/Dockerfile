FROM debian:stretch

RUN apt-get update \
    && apt-get install -y sudo apache2 openssl \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod proxy_fcgi ssl rewrite proxy proxy_balancer proxy_http proxy_ajp

RUN groupadd -g 1000 app \
    && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN echo "app ALL=(ALL) NOPASSWD: /bin/cp -f /var/www/conf/apache/000-default.conf /etc/apache2/sites-enabled/" >> /etc/sudoers.d/app

ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $HTTPD_PREFIX/bin:$PATH
RUN mkdir -p "$HTTPD_PREFIX" \
    && chown app:app "$HTTPD_PREFIX"

RUN mkdir /sock && mkdir -p /var/run/apache2 && mkdir -p /var/lock/apache2 && mkdir -p /var/log/apache2
RUN chown -R app:app /sock /var/run/apache2 /var/lock/apache2 /var/log/apache2

RUN sed -i 's/www-data/app/g' /etc/apache2/envvars

RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /etc/ssl/private/ssl-cert-dev-local.key -out /etc/ssl/certs/ssl-cert-dev-local.pem -subj "/C=DE/ST=North Rhine-Westphalia/L=Cologne/O=Security/OU=Development/CN=dev.local"
RUN chown -R app:app /etc/ssl
RUN sed -i '/Global configuration/a \
ServerName dev.local \
' /etc/apache2/apache2.conf

COPY ./conf/000-default.conf /etc/apache2/sites-enabled/

RUN rm -f /run/apache2/apache2.pid

RUN sed -i 's/Listen 80/Listen 8000/g' /etc/apache2/ports.conf \
    && sed -i 's/Listen 443/Listen 8443/g' /etc/apache2/ports.conf
EXPOSE 8000 8443

WORKDIR $HTTPD_PREFIX
USER app:app
VOLUME /var/www

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["sh", "/docker-entrypoint.sh" ]

CMD ["apachectl", "-DFOREGROUND", "-e info"]