module API
	class AuthenticationController < Grape::API
		desc "User attempts to log in to the api"
		post :login do
			username = params[:email]
			password = params[:password]

			if @logins[username.to_sym] == password
				content_type :json
				{ token: token(username) }.to_json
			else
				halt 401
			end
		end
	end
end
