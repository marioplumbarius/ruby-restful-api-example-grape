#!/usr/bin/env rackup
# encoding: utf-8

# loads all required dependencies, files and configuration
RACK_ENV = 'development' unless defined?(RACK_ENV)
require File.expand_path('../config/boot.rb', __FILE__)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

# starts the application
run RESTFul::API
