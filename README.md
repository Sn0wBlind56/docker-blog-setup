# Introduction

This repository provides an example Docker configuration to start a blog with automatic TLS certificate
rotation (run daily). The `docker-compose` binary should be installed/executable.

# Required Secrets

Before applying the configuration in this directory to the machine, the following secrets should be defined.

- `/etc/secrets/mysql/root_password`
- `/etc/secrets/mysql/username`
- `/etc/secrets/mysql/password`
- `/etc/secrets/wordpress/mysql_username`
- `/etc/secrets/wordpress/mysql_password`
- `/etc/secrets/nginx/nginx.crt`
- `/etc/secrets/nginx/nginx.key`

## Generating a Self-Signed Certificate for NGINX

The self-signed certificate is needed as an intermediate solution, so NGINX can start up and certbot
can go through the TLS certificate request/renew flow. Once certbot successfully requested a certificate,
you can restart the NGINX container or wait for the automatic configuration reload (every 6 hours) to
configure the new certificate.

```bash
openssl req -x509 -newkey rsa:4096 -keyout nginx.key -out nginx.crt -days 365 -nodes \
    -subj "/C=US/ST=Oregon/L=Portland/O=Company Name/OU=Org/CN=www.example.com"
```

# Before Running `docker-compose`

## Configure Container Image Versions

Before using `docker-compose up -d` to start the containers, you'll want to make sure you're on recent
and supported versions. Make sure you pick a MySQL version that's compatible with the WordPress version
you want to roll out.

## Set Your Domain

In the `environment/certbot/start-certbot.sh` file, replace `www.example.com` and `example.com` with your
domain(s). You should also replace the `info@example.com` with a valid email address. The email address
doesn't need to have the same domain. As long as it's valid and you can access it, it should be fine.

# Starting the Containers

`cd environment && docker-compose up -d`
