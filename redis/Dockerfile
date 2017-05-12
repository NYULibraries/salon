FROM redis:3.0

ENV REDIS_PORT 6379

COPY redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf", "--port", "$REDIS_PORT"]
