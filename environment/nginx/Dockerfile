FROM nginx:1.17.9

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY dhparam.pem /etc/ssl/certs/dhparam.pem
COPY start-nginx.sh /scripts/start-nginx.sh
RUN chmod +rx /scripts/start-nginx.sh

VOLUME ["/run/secrets", "/var/www/certbot", "/etc/letsencrypt"]
