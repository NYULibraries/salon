# Salon
[![CircleCI](https://circleci.com/gh/NYULibraries/salon.svg?style=svg)](https://circleci.com/gh/NYULibraries/salon)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/salon/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/salon?branch=master)
[![Code Climate](https://codeclimate.com/github/NYULibraries/salon/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/salon)

Salon is a simple app that redirects from short key `identifier`s to real URLs. It makes your links permed.

## Developing

You can run the server without a container, but we recommend running tests within [docker](#docker) due to various dependencies.

To start, first have a local instance of [Redis](#redis) running at `localhost:6379`, then run:

```sh
$ bundle install
$ ./scripts/start.sh
```

If you have your instance of Redis running somewhere else, use the `REDIS_HOST` environment
variable:

```sh
$ REDIS_HOST=www.redis.com:6000 ./scripts/start.sh
```

### Redis

[Redis](https://redis.io/) is our preferred key-value store. Without Redis running, the application won't work. To start redis locally run:

```sh
$ docker run -p 6379:6379 redis:3.2.8
```

If you have a custom redis Dockerfile, you can use it:

```sh
$ docker build ./redis -t my_redis
$ docker run -p 6379:6379 my_redis
```

This will spin up a redis instance at `http://{DOCKERHOST}:6379`

### Docker Compose

You can also run the stack within [Docker Compose](https://docs.docker.com/):

```
docker-compose up -d
```

Start a Salon server for the arch:

```
docker-compose exec arch ./scripts/start.sh arch
```

Then visit your `http://{DOCKERHOST}:9292`/`http://{docker-machine ip}:9292` to see the app in development.

## Usage

### API

Full interactive specification: https://nyulibraries.github.io/salon/

Salon authenticates using a token-based NYU Libraries OAuth at https://login.library.nyu.edu. Include tokens in header as `Bearer`.

| Path | Method | Summary | Example | Auth |
| ----|----|----|----|----|
| / | POST | Create persistent link | `{'id':'abc123', 'url':'http://example.com'}` | Required |
| /create_empty_resource | POST | Create empty persistent link – serves ID reserved | N/A | Required |
| /create_with_array | POST | Create persistent links | `[{'id':'abc123', 'url':'http://example.com'},{'url':'http://nyu.edu'}]` | Required |
| /reset_with_array | POST | Destroy existing links after creating new persistent links | `[{'id':'abc123', 'url':'http://example.com'},{'url':'http://nyu.edu'}]` | Admin-Only |
| /{id} | GET | Follow a persistent link | /abc123 | N/A |

## Testing

We recommend running tests in docker-compose `test` instance since it installs necessary dependencies:

```
docker-compose run test rake
```

Run rspec tests:

```
docker-compose run test rake spec
```

Run [dredd](https://github.com/apiaryio/dredd) tests, which check API JSON functionality against the [Swagger YAML](#swagger):

```
docker-compose run test rake dredd
```

