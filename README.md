# Permalinks
[![CircleCI](https://circleci.com/gh/NYULibraries/permalinks.svg?style=svg)](https://circleci.com/gh/NYULibraries/permalinks)

Permalinks is a simple app that redirects from short key `identifier`s to real URLs.

## Getting Started

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

### Redis

Redis is our preferred key-value store. Without Redis running, the application won't work. To start redis locally run:

```sh
$ redis-server -D
```

If you have configurations files for redis, you can use them:

```sh
$ redis-server /path/to/redis.conf -D
```

### Docker

You can also run the application within docker:

```
$ docker-compose up -d
# Run the tests
$ docker-compose run app rspec
# Start the dev server
$ docker-compose run --service-ports -e REDIS_ADDRESS=http://redishost:6379 app rackup -o 0.0.0.0
```

Visit your `http://dockerhost:9292`/`http://{docker-machine ip}:9292` to see the app in development.

## Usage

### API

#### `GET /`

To access permalinks with key `KEY`, visit `http://localhost:9292/KEY`

#### `POST /`

To use POST functions in the API, you must have an authentication token.

To create new permalinks:

```
curl -H "Content-Type: application/json" \
  -H "Auth: $SALON_AUTH_TOKEN" \
  -X POST \
  -d '{"key":"http://example.com"}' \
  http://localhost:9292 -v
```

#### `POST /reset`

To reset all permalinks (destroying all existing permalinks except those in the POST JSON data):

```
curl -H "Content-Type: application/json" \
  -H "Auth: $SALON_AUTH_TOKEN" \
  -X POST \
  -d @permalinks.json \
  http://localhost:9292/reset -v
```

## Stack notes

### Sinatra

`permalinks.rb` inherits from a Sinatra app and has it's own cache defined. The cache is a Redis instance. Since it's a modular style sinatra app, it's best to run it with a `config.ru`. See [Sinatra Documentation](http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps) for more information.

### Unicorn

We use Unicorn to serve our app. `unicorn.rb` has all our configurations for unicorn, thus we simply run

```sh
$ bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME
```

to start `permalinks`.
