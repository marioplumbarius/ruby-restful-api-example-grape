# Grape's RESTFul API example

[![Build Status](https://travis-ci.org/marioluan/ruby-restful-api-example-grape.svg?branch=master)](https://travis-ci.org/marioluan/ruby-restful-api-example-grape)
[![Code Climate](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/gpa.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape)
[![Test Coverage](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/coverage.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/coverage)
[![Issue Count](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/issue_count.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape)
[![Dependency Status](https://gemnasium.com/marioluan/ruby-restful-api-example-grape.svg)](https://gemnasium.com/marioluan/ruby-restful-api-example-grape)
[![Inline docs](http://inch-ci.org/github/marioluan/ruby-restful-api-example-grape.svg?branch=master)](http://inch-ci.org/github/marioluan/ruby-restful-api-example-grape)
***

## build.image
```
$ source .env-host
$ docker build -t $APP_IMAGE_NAME .
```

## unit.tests
```
$ source .env-host
$ docker run \
    --rm \
    -p $APP_HOST_PORT:$APP_GUEST_PORT/tcp \
    --name $APP_CONTAINER_NAME \
    --env-file .env-guest \
    $APP_IMAGE_NAME bundle exec rspec
```

## code.style:
```
$ source .env-host
$ docker run \
    --rm \
    -p $APP_HOST_PORT:$APP_GUEST_PORT/tcp \
    --name $APP_CONTAINER_NAME \
    --env-file .env-guest \
    $APP_IMAGE_NAME bundle exec rubocop -S
```

## tasks & migrations:
```
$ source .env-host
$ docker run \
    --rm \
    -p $APP_HOST_PORT:$APP_GUEST_PORT/tcp \
    --name $APP_CONTAINER_NAME \
    --env-file .env-guest \
    $APP_IMAGE_NAME bundle exec rake -T
```

## run.container
**load environment variables**
```
$ source .env-host
```
**start redis server**
```
$ docker run --name $REDIS_CONTAINER_NAME -p $REDIS_PORT:$REDIS_PORT -d $REDIS_IMAGE_NAME
```
**start application**
```
$ docker run \
    --rm \
    -p $APP_HOST_PORT:$APP_GUEST_PORT/tcp \
    --name $APP_CONTAINER_NAME \
    --link $REDIS_CONTAINER_NAME:redis \
    --env-file .env-guest \
    $APP_IMAGE_NAME bundle exec rackup --host $APP_GUEST_HOST -p $APP_GUEST_PORT
```
