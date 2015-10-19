#!/bin/bash

if [ ! -f "/.first_run" ]; then
  echo "  host: ${PG_PORT_5432_TCP_ADDR:?MISSING LINK: Postgresql must be linked in as pg}" >> /etc/foreman/database.yml
  RAILS_ENV=production foreman-rake db:migrate
  RAILS_ENV=production foreman-rake db:seed
  RAILS_ENV=production foreman-rake permissions:reset # Outputs the admin password.
  echo "PASSWORD IS ABOVE ^^^^^"
  touch /etc/foreman/.first_run
fi

sed -i "s/REPLACE_HOSTNAME/${VHOST_NAME:?ERROR: VHOST_NAME env var not set}/g" /etc/nginx/sites-enabled/foreman.conf
