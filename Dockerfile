FROM ruby:2.5.1-alpine3.7
MAINTAINER Doni Leong <doni.leong@gmail.com>

# Set up dependencies
ENV BUILD_PACKAGES="build-base git bash curl dcron" \
		DEV_PACKAGES="bzip2-dev libgcrypt-dev libxml2-dev libxslt-dev postgresql-dev yaml-dev sqlite-dev zlib-dev libc-dev libffi-dev imagemagick" \
		RAILS_DEPS="ca-certificates nodejs tzdata yarn" \
		APP="/app/webapp"

RUN \
  # sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories && \
	apk add --no-cache --update --upgrade --virtual .railsdeps $BUILD_PACKAGES $DEV_PACKAGES $RAILS_DEPS \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && mkdir -p "$APP" \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
    } >> $HOME/.gemrc \
	&& gem install bundler \
	&& rm -rf /var/cache/apk/* \
  && mkdir ~/.ssh \
  && chmod 700 ~/.ssh \
	&& mkdir -p $APP \
  && gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
  && npm config set registry https://registry.npm.taobao.org \
  && yarn config set registry https://registry.npm.taobao.org \
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories

WORKDIR $APP

EXPOSE 3000
