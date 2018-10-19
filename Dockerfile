FROM ruby:2.5.1-alpine

ENV INSTALL_PATH /app

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

COPY --chown=docker:docker Gemfile Gemfile.lock ./
ENV RUBY_BUILD_PACKAGES ruby-dev build-base linux-headers
RUN apk add --no-cache $RUBY_BUILD_PACKAGES \
  && bundle config --local github.https true \
  && gem install bundler && bundle install --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $RUBY_BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle

RUN mkdir coverage && chown docker:docker coverage

COPY --chown=docker:docker . .

# run microscanner
USER root
ARG AQUA_MICROSCANNER_TOKEN
RUN wget -O /microscanner https://get.aquasec.com/microscanner && \
  chmod +x /microscanner && \
  /microscanner ${AQUA_MICROSCANNER_TOKEN} && \
rm -rf /microscanner

USER docker

EXPOSE 9292

CMD ./scripts/start.sh arch
