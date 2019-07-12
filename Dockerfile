FROM ruby:2.6.3-alpine

ENV INSTALL_PATH /app
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV USER docker
ENV BUNDLER_VERSION='2.0.1'

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

COPY --chown=docker:docker Gemfile Gemfile.lock ./
ENV RUBY_BUILD_PACKAGES ruby-dev build-base linux-headers
ARG BUNDLE_WITHOUT="test"
RUN apk add --no-cache $RUBY_BUILD_PACKAGES \
  && gem install bundler -v ${BUNDLER_VERSION} \
  && bundle config --local github.https true \
  && bundle install --without $BUNDLE_WITHOUT --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $RUBY_BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle

RUN mkdir coverage && chown docker:docker coverage

COPY --chown=docker:docker . .

# run microscanner
ARG AQUA_MICROSCANNER_TOKEN
RUN wget -O /microscanner https://get.aquasec.com/microscanner && \
  chmod +x /microscanner && \
  /microscanner ${AQUA_MICROSCANNER_TOKEN} && \
rm -rf /microscanner

USER docker

EXPOSE 9292

CMD ./scripts/start.sh arch
