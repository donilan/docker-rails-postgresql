FROM ruby:2.3.5

ENV BUILD_PACKAGES="bash curl tzdata ca-certificates wget less ssh" \
    DEV_PACKAGES="ruby-dev libc-dev libffi-dev libmysqlclient-dev libxml2-dev libxslt-dev libgmp3-dev" \
    RUBY_PACKAGES="postgresql-client git openssl" \
    GEM_HOME=/app/bundle \
    BUNDLE_PATH=/app/bundle \
    BUNDLE_APP_CONFIG=/app/bundle \
    APP=/app/webapp \
    PATH=/app/webapp/bin:/app/bundle/bin:$PATH

RUN set -ex \
    && apt-get update \
    && apt-get install -qq -y --force-yes build-essential --fix-missing --no-install-recommends \
    $BUILD_PACKAGES \
    $DEV_PACKAGES \
    $RUBY_PACKAGES \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get -y install python build-essential nodejs \
    && npm install -g yarn@0.25.2 \
    && mkdir -p "$APP" "$GEM_HOME/bin" \
    && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
    } >> ~/.gemrc \
    && apt-get clean \
    && rm -rf '/var/lib/apt/lists/*' '/tmp/*' '/var/tmp/*' \
    && mkdir ~/.ssh \
    && chmod 700 ~/.ssh

RUN gem install bundler
RUN gem install rails -v '~> 5.1.4'
RUN gem install backup -v '~> 4.4.0'

WORKDIR $APP

EXPOSE 3000
