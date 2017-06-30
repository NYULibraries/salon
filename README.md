# Salon
[![CircleCI](https://circleci.com/gh/NYULibraries/salon.svg?style=svg)](https://circleci.com/gh/NYULibraries/salon)

Salon is a simple app that redirects from short key `identifier`s to real URLs. It makes your links permed.

## Getting Started

To start, first have a local instance of Redis running at `localhost:6379` (see below), then run:

```sh
$ bundle install
$ bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME
```

If you have your instance of Redis running somewhere else, use the `REDIS_HOST` environment
variable:

```sh
$ REDIS_HOST=www.redis.com:6000 bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME -D
```

### Redis

Redis is our preferred key-value store. Without Redis running, the application won't work. To start redis locally run:

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

You can also run the stack within Docker Compose:

```
# Start the dev services up
$ docker-compose up -d
# Run the tests
$ docker-compose run test rake
```

Visit your `http://{DOCKERHOST}:9292`/`http://{docker-machine ip}:9292` to see the app in development.

## Usage

### API

Full interactive specification: https://nyulibraries.github.io/salon/

#### `GET /`

To access permalinks with key `KEY`, visit `http://localhost:9292/KEY`

#### `POST /`

To use POST functions in the API, you must have an authentication token.

To create new permalinks:

```
curl -H "Content-Type: application/json" \
  -H "Authentication: Bearer $ACCESS_TOKEN" \
  -X POST \
  -d '{"key":"http://example.com"}' \
  http://localhost:9292 -v
```

#### `POST /reset`

To reset all permalinks (destroying all existing permalinks except those in the POST JSON data):

```
curl -H "Content-Type: application/json" \
  -H "Authentication: Bearer $ACCESS_TOKEN" \
  -X POST \
  -d @permalinks.json \
  http://localhost:9292/reset -v
```

## Testing

Run all tests:

```
rake
```

Run rspec tests, which check HTML functionality:

```
rake spec
```

Run [dredd](https://github.com/apiaryio/dredd) tests, which check API JSON functionality against the [Swagger YAML](#swagger):

```
rake dredd
```

### Preparing tests

#### Preparing specs

**Note** You only have to perform this prep work if something has changed. It has already been setup and shouldn't need to be setup anew each time.

To test the OAuth2 authentication method in RSpec we need to setup some dummy OAuth applications in our provider. You could do this in staging or production (i.e. dev.login.library.nyu.edu, login.library.nyu.edu) or run the Login application in a local docker container.

To run the application locally in docker, first build the docker compose:

```
cd ~/login
docker-compose up -d
```

Edit `config/initializers/doorkeeper.rb` to disable forced SSL and replace existing `admin_authenticator` block:

```
# Add this line
force_ssl_in_redirect_uri false

admin_authenticator do
  # Replace existing
  current_user
end
```

Then start the server:

```
docker-compose exec web rails s -b 0.0.0.0
```

This brings up the login application with a logged in admin user at or `${DOCKERHOST}:3000`

You can now navigate to `http://dockerhost:3000/oauth/applications` to create two new applications, one for admin and one for non-admin. Those client credentials can then be used to create access tokens:

```
curl -X POST \
  -d grant_type=client_credentials \
  -d client_id=$CLIENT_ID \
  -d client_secret=$CLIENT_SECRET \
  -d scope=admin \
  http://dockerhost:3000/oauth/token -v
# Or with httpie
http POST http://dockerhost:3000/oauth/token grant_type=client_credentials client_id=$CLIENT_ID client_secret=$CLIENT_SECRET scope=$SCOPE
```

Omit `scope=admin` for non-admin request.

Use the access tokens generated to run your specs:

```
TOKEN={NONADMINTOKEN} ADMIN_TOKEN={ADMINTOKEN} OAUTH2_SERVER={DOCKERHOST} rspec
```

After the first run, VCR generates cassettes to stub the request for subsequent runs until an edit is made to the application.

#### Preparing dredd

Use client credentials of an existing application in Login Dev called "Salon Test Admin" to run your rake task so dredd can setup a valid OAuth2 session before each test:

```
TEST_CLIENT_ID={SALON_TEST_CLIENT_ID} TEST_CLIENT_SECRET={SALON_TEST_CLIENT_SECRET} rake      
```

If you're running these tests in circle or with docker compose there shouldn't be any connectivity issues with redis, but if you're running them locally you may need to set the `REDIS_HOST` variable

## Stack notes

### Sinatra

`permalinks.rb` inherits from a Sinatra app and has it's own cache defined. The cache is a Redis instance. Since it's a modular style sinatra app, it's best to run it with a `config.ru`. See [Sinatra Documentation](http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps) for more information.

### Unicorn

We use Unicorn to serve our app. `unicorn.rb` has all our configurations for unicorn, thus we simply run

```sh
$ bundle exec unicorn -c unicorn.rb -E ENVIRONMENT_NAME
```

to start `permalinks`.

### Swagger

Swagger describes the API in a YAML format such that documentation can be automatically generated on the `gh-pages` branch. We can also test against it using dredd.

Since Swagger is picky about specification syntax, edit the YAML within the Swagger Editor – either on its [website](http://editor.swagger.io/) or via docker:

```
docker pull swaggerapi/swagger-editor
docker run -p 8080:8080 swaggerapi/swagger-editor
```
