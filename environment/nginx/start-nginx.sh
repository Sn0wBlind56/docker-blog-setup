#!/bin/sh

# Copy Let's Encrypt certificate chain
copy_certbot_chain() {
  if [ -d "/etc/letsencrypt/nginx" ] && [ -f "/etc/letsencrypt/nginx/nginx.key" ] && [ -f "/etc/letsencrypt/nginx/nginx.crt" ]
  then
    echo "Let's Encrypt private key and certificate found, copying to /etc/nginx/tls"
    # backslash in front of cp command to avoid using alias
    \cp /etc/letsencrypt/nginx/nginx.key /etc/nginx/tls/nginx.key
    \cp /etc/letsencrypt/nginx/nginx.crt /etc/nginx/tls/nginx.crt
  else
    echo "No Let's Encrypt key and certificate found, using the ones under /run/secrets and copying them to /etc/nginx/tls"
    # backslash in front of cp command to avoid using alias
    \cp /run/secrets/nginx.key /etc/nginx/tls/nginx.key
    \cp /run/secrets/nginx.crt /etc/nginx/tls/nginx.crt
  fi
}

mkdir -p /etc/nginx/tls
copy_certbot_chain

# Reload NGINX configuration every 6 hours
while true
do
  sleep 6h &
  wait
  copy_certbot_chain
  echo "$(date) - Reloading NGINX configuration"
  nginx -s reload
done &

nginx -g "daemon off;"
