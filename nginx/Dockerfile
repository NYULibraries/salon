FROM nginx:1.13

COPY nginx.conf /etc/nginx/nginx.conf
ADD conf.d /etc/nginx/conf.d

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]
