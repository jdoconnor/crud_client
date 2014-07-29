require 'pry'
require 'simplecov'
ENV['RACK_ENV'] = 'test'
SimpleCov.start do
  add_filter "/spec\/.*/"
end
require 'crud_client'
