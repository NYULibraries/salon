FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
ADD conf.d/salon.conf /etc/nginx/conf.d/salon.conf

CMD [ "nginx", "-g", "daemon off;" ]
