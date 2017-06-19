require './app'
require 'dotenv'

Dotenv.load if File.exists?('.env')

run Sinatra::Application
