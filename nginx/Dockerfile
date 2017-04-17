FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/salon.conf /etc/nginx/conf.d/salon.conf

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]
