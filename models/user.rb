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
    field :login_attempt, type: DateTime, default: DateTime.now
    field :failed_attempts, type: Integer, default: 0
	has_many :rat_sighting, validate: false
	has_one :token, validate: false
	validates :email, presence: true, uniqueness: true
	validates_confirmation_of :password, on: :create
	validates :password, presence: true, length: {minimum: 6}, on: :create

	class << self # Class methods
		def find_by_email(email)
			first(conditions: {email: email})
		end

		def authenticate(email, password)
			user = User.find_by(email: email)
            if password_correct?(email, password)
				return JsonWebToken.encode(user_id: user.id)
            end

            unless user.nil?
                user.update!(failed_attempts: user.failed_attempts + 1)
                return
            end
		end

        def password_correct?(email, password)
			user = User.find_by(email: email)
			return if user.nil?
			BCrypt::Engine.hash_secret(password, user.salt) == user.password_digest
        end
	end

    def brute_force_detected?
        if (self.login_attempt >= DateTime.now - 5.minutes)
            puts "try again in #{self.login_attempt + 5.minutes - DateTime.now} seconds"
            return failed_attempts > 3
        else
            puts "I'm over here now!"
            self.login_attempt = DateTime.now
            self.failed_attempts = 0
            save
            return true
        end
    end

    protected
    def encrypt_password
        puts "This is happening"
		self.salt = BCrypt::Engine.generate_salt
		self.password_digest = BCrypt::Engine.hash_secret(password, salt)
    end
end
