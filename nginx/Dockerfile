FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/salon.conf /etc/nginx/conf.d/salon.conf

EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]
