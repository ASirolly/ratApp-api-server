require 'bcrypt'
require 'SecureRandom'

class User
	include Mongoid::Document
	include Mongoid::Timestamps
	include BCrypt
	before_save :generate_salt, :encrypt_password
	attr_accessor :password, :password_confirmation
	# define all of the fields we will be saving into mongodb
	field :email, type: String
	field :salt, type: String
	field :first_name, type: String
	field :last_name, type: String
	field :password_digest, type: String
	field :admin, type: Boolean

	has_many :rat_sighting, validate: false
	validates_confirmation_of :password

	# Fancy trick for class methods, ask me if you want more info
	class << self
		def find_by_email(email)
			first(conditions: {email: email})
		end

		def authenticate(email, password)
			# I'm just forwarding the call right here, but I will probably have to do something more fancy soon
			password_correct(email, password)
		end

		def password_correct?(email, password)
			user = User.find_by_email(email)
			return if user.nil?
			user_pass = Password.new(user.password_digest)
			(@password + user.salt) == user_pass
		end
	end

	protected
	def generate_salt
		self.salt = SecureRandom.urlsafe_base64
	end
	def encrypt_password
		salted_password = @password + salt
		self.password_digest = Password.create(password: salted_password)
	end
end
