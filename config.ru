#!/usr/bin/env rackup
# encoding: utf-8

# loads all required dependencies, files and configuration
require File.expand_path('../config/boot.rb', __FILE__)

# configures database connection pool
use ActiveRecord::ConnectionAdapters::ConnectionManagement

# starts the application
run RESTFul::API
