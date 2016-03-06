# Grape's RESTFul API example

[![Build Status](https://travis-ci.org/marioluan/ruby-restful-api-example-grape.svg?branch=master)](https://travis-ci.org/marioluan/ruby-restful-api-example-grape)
[![Code Climate](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/gpa.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape)
[![Test Coverage](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/coverage.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/coverage)
[![Issue Count](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape/badges/issue_count.svg)](https://codeclimate.com/github/marioluan/ruby-restful-api-example-grape)
[![Dependency Status](https://gemnasium.com/marioluan/ruby-restful-api-example-grape.svg)](https://gemnasium.com/marioluan/ruby-restful-api-example-grape)
[![Inline docs](http://inch-ci.org/github/marioluan/ruby-restful-api-example-grape.svg?branch=master)](http://inch-ci.org/github/marioluan/ruby-restful-api-example-grape)
***

***Note: Head over [README-docker.md](/README-docker.md) to run the application as a container.***

## pre.requisites:
* sqlite3 (v3.8.5)
* redis (v3.0.0)
* ruby (v2.2.3)

## install.dependencies
```
$ bundle install
```

## unit.tests
```
$ bundle exec rspec
```

### code.coverage:
Code coverage report is available at ./coverage/index.html. The report is updated every time unit tests are executed.

## code.style:
```
$ bundle exec rubocop -S
```

## tasks & migrations:
Tasks are defined inside ./lib/tasks directory. The only task we have today is a sample rake task and another one which loads active record tasks, such as migrations' tasks.
```
$ bundle exec rake -T
```

## run.application
**load environment variables**
```
$ source .env-host
```
**start redis server**
```
$ redis-server
```
**run migrations**
```
$ bundle exec rake db:setup
$ bundle exec rake db:migrate
```
**start application**
```
$ bundle exec rackup --host $APP_GUEST_HOST -p $APP_GUEST_PORT
```

## api.documentation (in development)
Head over http://$APP_GUEST_HOST:$APP_GUEST_PORT/api/swagger_doc to see a JSON representation.

Open http://petstore.swagger.io/?url=http://$APP_GUEST_HOST:$APP_GUEST_PORT/api/swagger_doc in your browser to navigate the documentation (remember to enable CORS if necessary).

--

# draft
## project.structure:
TODO - describe what is the content from each package/folder

1. apis
1. entities
1. params
1. formatters
1. helpers
1. middlewares
1. models
1. providers

## available.configuration:
TODO - describe how the app can be configured:
- which environment variables are available
- .env
- .rspec
- .rubocop.yml
- .travis.yml
- etc

## travis:
TODO - explain content from .travis.yml and what happens when pushes are sent to master branch

## gems:
TODO - talk about used gems, what motivated me to use them
