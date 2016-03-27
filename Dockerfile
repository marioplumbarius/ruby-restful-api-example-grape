FROM ruby:2.2.4-alpine

MAINTAINER Mario Luan <mariosouzaluan@gmail.com>

# dependencies
ENV GENERAL_PACKAGES build-base
ENV NOKOGIRI_PACKAGES libxml2-dev libxslt-dev
ENV SQLITE_PACKAGES sqlite-dev

# install dependencies
RUN apk add --update $GENERAL_PACKAGES
RUN apk add --update $NOKOGIRI_PACKAGES
RUN apk add --update $SQLITE_PACKAGES

# sets the working directory
ADD . /app
WORKDIR /app

# builds the app
# forces nokogiri to use the installed $NOKOGIRI_PACKAGES
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --path vendor/bundle

# default command executed for the underlying image
CMD bundle exec rackup --host 0.0.0.0 -p 5000

# server
EXPOSE 5000