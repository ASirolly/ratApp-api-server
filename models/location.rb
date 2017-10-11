class Location
	include Mongoid::Document
	include Mongoid::Timestamps
	# Fields
	field :longitude, type: Float
	field :latitude, type: Float

	# Relations
	embedded_in :locable, polymorphic: true

	# Scoping and indexing
	scope :ordered, -> {order('created_at DESC')}

	#validations
	validates :slug, presence: true, uniqueness: true
	validates :longitude, :latitude, presence: true
end
