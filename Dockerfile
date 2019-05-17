FROM debian:stretch
MAINTAINER Meritoo <github@meritoo.pl>

ARG NGINX_PORT

#
# Tools & libraries
#
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# Configuration
#
COPY conf/nginx.conf /etc/nginx/
COPY conf/application.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/application.conf /etc/nginx/sites-enabled/application \
    && rm /etc/nginx/sites-enabled/default \
    && echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf \
    && usermod -u 1000 www-data

#
# Bash
#
RUN sed -i 's/^# export/export/g; \
            s/^# alias/alias/g;' ~/.bashrc \
    && echo 'COLUMNS=200'"\n" >> ~/.bashrc

CMD ["nginx"]
WORKDIR /var/www/application
EXPOSE ${NGINX_PORT}
