#!/usr/bin/env rackup
# encoding: utf-8

# boots the application
# loads all required dependencies, files and configuration
require File.expand_path('../config/boot.rb', __FILE__)

# starts the application
run RESTFul::API