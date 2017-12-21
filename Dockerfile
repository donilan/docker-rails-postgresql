FROM ruby:2.4.3

ENV BUILD_PACKAGES="bash curl tzdata ca-certificates wget" \
    DEV_PACKAGES="ruby-dev libc-dev libffi-dev libxml2-dev libxslt-dev libgmp3-dev" \
    RUBY_PACKAGES="postgresql-client git openssl" \
    GEM_HOME=/app/bundle \
    BUNDLE_PATH=/app/bundle \
    BUNDLE_APP_CONFIG=/app/bundle \
    APP=/app/webapp \
    PATH=/app/webapp/bin:/app/bundle/bin:$PATH

RUN set -ex \
    && apt-get update \
    && apt-get install -qq -y --force-yes build-essential --fix-missing --no-install-recommends $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get -y install python build-essential nodejs \
    && npm install -g yarn@0.25.2 \
    && mkdir -p "$APP" "$GEM_HOME/bin" \
    && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
    } >> ~/.gemrc \
    && gem install bundler \
    && apt-get clean \
    && rm -rf '/var/lib/apt/lists/*' '/tmp/*' '/var/tmp/*' \
    && mkdir ~/.ssh \
    && chmod 700 ~/.ssh \
    && gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    && npm config set registry https://registry.npm.taobao.org \
    && yarn config set registry https://registry.npm.taobao.org

WORKDIR $APP

EXPOSE 3000
