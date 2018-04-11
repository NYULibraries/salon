FROM ruby:2.4

RUN apt-get update -qq && apt-get install -y \
  curl \
  git \
  vim

ENV INSTALL_PATH /app

RUN groupadd -g 2000 docker -r && useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER 1000

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without test

COPY . .
