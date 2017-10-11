class City
	include Mongoid::Document
	include Mongoid::Timestamps
	before_save :normalize_name
	#fields
	field :name, type: String
	embeds_many :location
	
	validates :name, presence: true, uniqueness: true

	protected
	def normalize_name
		self.name = name.downcase!
	end
end
