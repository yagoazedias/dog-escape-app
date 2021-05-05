FROM tobi312/rpi-nginx:latest

EXPOSE 5000

COPY ./build/web /usr/share/nginx/html

COPY ./build/web /var/www/html