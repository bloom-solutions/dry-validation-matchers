

# First load and start simplecov
require 'simplecov'
SimpleCov.minimum_coverage 90
SimpleCov.minimum_coverage_by_file 80
SimpleCov.maximum_coverage_drop 5
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pry"
require "pry-byebug"
require "dry/validation/matchers"
