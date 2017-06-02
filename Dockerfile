FROM ruby:2.4

RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y lsof telnet redis-server

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g dredd

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

COPY Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .
