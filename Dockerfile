FROM nginx:latest

EXPOSE 5000

COPY ./build/web /usr/share/nginx/html