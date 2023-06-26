FROM ruby:3.2.2-alpine

ENV INSTALL_PATH /app
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV BUNDLER_VERSION='2.4.13'

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUBY_BUILD_PACKAGES="ruby-dev build-base linux-headers"
ARG BUNDLE_WITHOUT="test"
RUN apk --no-cache --upgrade add ${RUBY_BUILD_PACKAGES} \ 
  && gem install bundler -v ${BUNDLER_VERSION} \
  && bundle config --local github.https true \
  && bundle install --without $BUNDLE_WITHOUT --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del ${RUBY_BUILD_PACKAGES} \
  && chown -R docker:docker /usr/local/bundle

RUN mkdir coverage && chown docker:docker coverage

USER docker

COPY --chown=docker:docker . .

EXPOSE 9292

CMD ["puma", "config.ru", "-C", "config/puma.rb"]
