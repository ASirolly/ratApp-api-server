require 'grape'
require 'mongoid'
require 'pry'
# Load files from the models and api folders

Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/api/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/config/**/*.rb"].each {|f| require f}
puts ENV['env_name']
#binding.pry
Mongoid.load! "config/mongoid.config"

binding.pry
# Wrapping the api in a module for organizational reasons
# Grape API class. Grape is the framework we are using.
module API
  class Root < Grape::API
		#note these options
    format :json
    prefix :api

    # Hello world endpoint
    get :hello_world do
      { status: 'Hello World' }
    end

	 	mount ::API::UsersController
		mount ::API::RatSightingsController
  end
end
## Below is a commented out way to get stop the application and open a command line tool called pry right in the application environment
#binding.pry

# packing it all up into a single object
RatAppServer = Rack::Builder.new {
  map "/" do
    run API::Root
  end

}

=begin
We are mapping our API to the root ("/") of our rack web-server, but specify a prefix in the root class. This means any request made to /api/ are handled by our API::Root class

i.e.) a get request made to /api/hello_world will be routed to our hello world endpoint in the API::Root class
=end
