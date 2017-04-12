# Permalinks
[![CircleCI](https://circleci.com/gh/NYULibraries/permalinks.svg?style=svg)](https://circleci.com/gh/NYULibraries/permalinks)

Permalinks is a simple app that redirects from short key `identifier`s to real URLs.

To start, first have a local instance of Redis running at `localhost:6379`, then run:

```sh
$ bundle install
$ bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME
```

If you have your instance of Redis running somewhere else, use the `REDIS_ADDRESS` environment
variable:

```sh
$ REDIS_ADDRESS=www.redis.com:6000 bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME -D
```

## Sinatra

`permalinks.rb` inherits from a Sinatra app and has it's own cache defined. The cache is a Redis instance. Since it's a modular style sinatra app, it's best to run it with a `config.ru`. See [Sinatra Documentation](http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps) for more information.

## Unicorn

We use Unicorn to serve our app. `unicorn.rb` has all our configurations for unicorn, thus we simply run

```sh
$ bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME
```

to start `permalinks`.

## Redis

Redis is our preferred key-value store. Without Redis running, the application won't work. To start redis locally run:

```sh
$ redis-server -D
```

If you have configurations files for redis, you can use them:

```sh
$ redis-server /path/to/redis.conf -D
```
