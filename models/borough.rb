class Borough
	include Mongoid::Document
	include Mongoid::Timestamps
	before_save :normalize_name
	#fields
	field :name, type: String
	has_many :location

	validates :name, presence: true, uniqueness: true

	protected
	def normalize_name
		self.name = name.downcase!
	end
end
