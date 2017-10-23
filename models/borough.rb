class Borough
	include Mongoid::Document
	include Mongoid::Timestamps
	before_save :normalize_name
	#fields
	attr_accessor :name
	field :name, type: String
	has_many :location, validate: false

	validates :name, presence: true, uniqueness: true

	protected
	def normalize_name
		self.name = name.downcase
	end
end
