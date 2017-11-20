require 'mongoid'
require "../models/user.rb"
require 'rspec'
ENV['RACK_ENV'] = "test"
Mongoid.load! "../config/mongoid_test.config"

describe User do
	before(:each) do
		@user_params = {:email => "test@test.com", :first_name => "test", 
								:last_name => "test", :password => "password",
								:password_confirmation => "password"}
	end
	
	describe "creating a new account" do
		context "invalid parameters" do
			it "is not valid without email" do
				@user_params[:email] = nil

				user = User.create(@user_params)
				user.valid?
				expect(user.errors[:email]).to include("can't be blank")
			end
			it "is not valid without password_confirmation" do
				@user_params[:password_confirmation] = ""
				user = User.create(@user_params)
				user.valid?
				expect(user.errors[:password_confirmation]).to include("doesn't match Password")

			end
			it "is not valid without a password of length 6 or greater" do
				valid_pass = "a" * 6 		#"aaaaaa"
				invalid_pass = "a" * 5  #"aaaaa"
				@user_params[:password] = @user_params[:password_confirmation] = invalid_pass
				user = User.create(@user_params)
				puts user.errors
				expect(user).to_not be_valid
			end
		end
		context "valid parameters" do
			it "allows creation of the first account" do
				user = User.create(@user_params)
				expect(User.all.count).to eq(1)
			end

			it "doesn't allow for duplicates" do
				user = User.create(@user_params)
				expect(user).not_to be_valid
			end
		end
	end
end
