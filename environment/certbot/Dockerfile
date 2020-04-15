FROM certbot/certbot:latest

COPY start-certbot.sh /scripts/start-certbot.sh
RUN chmod +rx /scripts/start-certbot.sh

VOLUME ["/var/www/certbot", "/etc/letsencrypt"]
