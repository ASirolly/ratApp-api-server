module API
	class AuthenticationController < Grape::API
		desc "User attempts to log in to the api"
		post :login do
			username = params[:email]
			password = params[:password]
            user = User.find_by(email: username)
            unless (user.nil? || user.brute_force_detected?)
                puts @logins.to_s
                if @logins[username.to_sym] == password
                    content_type :json
                    { token: token(username) }.to_json
                else
                    error!('login invalid', 401)
                end
            end
		end
	end
end
