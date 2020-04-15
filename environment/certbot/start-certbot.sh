#!/bin/sh

initialize_certbot() {
  certbot certonly \
    --webroot \
    --webroot-path /var/www/certbot \
    -d www.example.com -d example.me \
    --email info@example.com \
    --rsa-key-size 4096 \
    --agree-tos \
    --non-interactive
}

renew_certificate() {
  echo "Starting Let's Encrypt certificate renewal process through certbot"
  certbot renew
}

copy_nginx_certificate() {
  if [ ! -d "/etc/letsencrypt/live/www.example.com" ]
  then
    echo "Let's Encrypt certificate chain directory not found, skipping copy"
    return 1
  fi

  echo "Copying Let's Encrypt certificate chain to directory indicated for usage by NGINX"
  mkdir -p /etc/letsencrypt/nginx
  # backslash in front of cp command to avoid using alias
  \cp /etc/letsencrypt/live/www.example.com/privkey.pem /etc/letsencrypt/nginx/nginx.key
  \cp /etc/letsencrypt/live/www.example.com/fullchain.pem /etc/letsencrypt/nginx/nginx.crt
}

if [ ! -d "/etc/letsencrypt/live" ]
then
  echo "No existing Let's Encrypt certificate found, initializing certbot"
  initialize_certbot
else
  echo "Existing Let's Encrypt certificate found, skipping initialization"
fi

trap exit TERM

while true
do
  renew_certificate
  copy_nginx_certificate
  sleep 1d &
  wait
done
