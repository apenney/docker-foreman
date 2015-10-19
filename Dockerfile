FROM phusion/passenger-ruby19
MAINTAINER Ashley Penney <apenney@ntoggle.com>

# Ensures apt doesn't ask us silly questions:
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Enable nginx and passenger
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD foreman-nginx.conf /etc/nginx/sites-enabled/foreman.conf

# Add the Foreman repos
RUN echo "deb http://deb.theforeman.org/ trusty 1.9" > /etc/apt/sources.list.d/foreman.list
RUN echo "deb http://deb.theforeman.org/ plugins 1.9" >> /etc/apt/sources.list.d/foreman.list
RUN curl http://deb.theforeman.org/pubkey.gpg | apt-key add -
RUN apt-get update --fix-missing && apt-get -y upgrade && \
    apt-get -y install foreman foreman-cli foreman-postgresql netcat
RUN apt-get -y clean

COPY database.yml /etc/foreman/database.yml
COPY first_run.sh /etc/my_init.d/00-first_run.sh

EXPOSE 80
EXPOSE 443

CMD ["/sbin/my_init"]
