FROM nginx:alpine

ENV NGINX_WORKER_PROCESSES auto

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
