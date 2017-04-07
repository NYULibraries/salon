FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN npm install -g phantomjs-prebuilt

ENV INSTALL_PATH /apps/salon
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

COPY Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .

CMD bundle exec unicorn -c unicorn.rb -E development -D
