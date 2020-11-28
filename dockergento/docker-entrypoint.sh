#!/bin/sh
set -e

if [ -f /var/www/conf/apache/000-default.conf ]; then
  sudo cp -f /var/www/conf/apache/000-default.conf /etc/apache2/sites-enabled/
fi

exec "$@"