require 'grape'
require 'grape-swagger'
require 'mongoid'
require 'pry'
# Load files from the models and api folders

Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/api/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/config/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each {|f| require f}
#binding.pry
Mongoid.load! "config/mongoid.config"
Mongoid.raise_not_found_error = false
# Wrapping the api in a module for organizational reasons
# Grape API class. Grape is the framework we are using.
module API
  class Root < Grape::API
  	content_type :json, 'application/json; charset=UTF-8'
		format :json
  	prefix :api
		
		attr_reader :current_user

	  before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

		helpers do
			def authenticate!
				error!('Unauthorized. Invalid or expired token.', 401) unless current_user
			end

			def current_user
				@current_user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
			end

			def decoded_auth_token
				@decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
			end
		
			def http_auth_header
				if request.headers['Authorization'].present?
				 	return request.headers['Authorization'].split(' ').last
				else 
					error!("No token found - make sure your auth token is in the header 'Authorization'", 401)
				end 
				nil
			end
		end

		# Hello world endpoint
    get :hello_world do
			authenticate!
      { status: 'Hello World' }
    end

	 	mount ::API::UsersController
		mount ::API::RatSightingsController
		mount ::API::LocationsController
		#creates documentation
		add_swagger_documentation
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
