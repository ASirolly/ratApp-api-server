require 'bcrypt'
include BCrypt
require 'securerandom'

class User
	include Mongoid::Document
	include Mongoid::Timestamps
	include BCrypt
	before_create :encrypt_password
	attr_accessor :password, :password_confirmation
	# define all of the fields we will be saving into mongodb
	field :email, type: String
	field :salt, type: String
	field :first_name, type: String
	field :last_name, type: String
	field :password_digest, type: String
	field :admin, type: Boolean

	has_many :rat_sighting, validate: false
	has_one :token
	validates :email, presence: true, uniqueness: true
	validates_confirmation_of :password
	validates :password, presence: true, length: {minimum: 6}

	class << self # Class methods
		def find_by_email(email)
			first(conditions: {email: email})
		end

		def authenticate(email, password)
			user = User.find_by(email: email)
			if password_correct?(email, password)
				JsonWebToken.encode(user_id: user.id)
			end
		end

		def password_correct?(email, password)
			user = User.find_by(email: email)
			return if user.nil?
			BCrypt::Engine.hash_secret(password, user.salt) == user.password_digest
		end
	end

	protected
	def encrypt_password
		self.salt = BCrypt::Engine.generate_salt
		self.password_digest = BCrypt::Engine.hash_secret(password, salt)
	end
end
