module API
	class UsersController < Grape::API
		resources :users do 
			desc 'Gets a list of all users'
			get do
				User.all
			end

			desc 'Create a new user'
			params do
				requires :email, type: String
				requires :password, type: String
				requires :password_confirmation, type: String
			end
			post do
				User.create!(email: params['email'], password: params['password'],
										 password_confirmation: params['password_confirmation'])
			end
		end

		desc 'validates credentials and returns an auth token'
		params do
			requires :email, type: String
			requires :password, type: String
		end

		post :login do
			token = User.authenticate(params[:email], params[:password])
			unless token.nil?
				{ auth_token: token }
			else
				halt 401
			end
		end
		
		# Cleans up parameter list that we will end up reusing
		def user_params
			{ first_name: params[:first_name],
			last_name: params[:last_name],
			:email => params[:email],
			password: params[:password],
			password_confirmation: params[:password_confirmation] }
		end
	end
end


