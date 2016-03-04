# Grape's RESTFul API example

[![Build Status](https://travis-ci.org/marioluan/ruby-restful-api-example-grape.svg?branch=master)](https://travis-ci.org/marioluan/ruby-restful-api-example-grape)
[![Code Climate](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/gpa.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape)
[![Test Coverage](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/coverage.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/coverage)
[![Issue Count](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/issue_count.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape)
[![Dependency Status](https://gemnasium.com/marioluan/ruby-restful-api-example-grape.svg)](https://gemnasium.com/marioluan/ruby-restful-api-example-grape)
[![Inline docs](http://inch-ci.org/github/marioluan/ruby-restful-api-example-grape.svg?branch=master)](http://inch-ci.org/github/marioluan/ruby-restful-api-example-grape)
***

## dependencies
- sqlite3 (v3.8.5)
- redis (v3.0.0)
- ruby (v2.2.3)

## project.structure:
TODO - describe what is the content from each package/folder
### apis
### entities
#### params
### formatters
### helpers
### middlewares
### models
### providers

## available.configuration:
TODO - describe how the app can be configured:
- which environment variables are available
- .env
- .rspec
- .rubocop.yml
- .travis.yml
- etc

## migrations:
The following tasks must be run before starting the application.
```
$ rake db:setup
$ rake db:migrate
```

## tasks:
Tasks are defined inside ./lib/tasks directory. The only task we have today is an example rake task and another task which loads active record tasks, such as migrations' tasks.

## unit.tests:
```
$ rspec
```

## code.coverage:
Code coverage report is available at ./coverage/index.html. The report is updated every time unit tests are executed.

## code.style:
```shell
$ rubocop -S
```

## travis:
TODO - explain content from .travis.yml and what happens when pushes are sent to master branch

## gems:
TODO - talk about used gems, what motivated me to use them

*Finally, let's run the app!*

## run
### from your local machine
```
$ rackaup
```

### from a docker container (see Dockerfile)
**load environment variables**
```
$ source .env
```
**run the application**
```
$ docker run \
    --rm \
    -p ${APP_HOST_PORT}:${APP_GUEST_PORT}/tcp \
    --name grape \
    --entrypoint="/bin/bash" \
    ruby/grape -l -c "bundle exec rackup --host ${APP_GUEST_HOST} -p ${APP_PORT}"
```

## test
**load environment variables**
```
$ source .env
```
**run the unit tests**
```
$ docker run \
    --rm \
    -p ${APP_HOST_PORT}:${APP_GUEST_PORT}/tcp \
    --name grape \
    --entrypoint="/bin/bash" \
    ruby/grape -l -c "bundle exec rspec"
```
