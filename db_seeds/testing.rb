require 'grape'
require 'mongoid'
require 'pry'
require 'CSV'

ENV["RACK_ENV"] = "development"

Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../api/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../config/**/*.rb"].each {|f| require f}

Mongoid.load! "../config/mongoid.config"
