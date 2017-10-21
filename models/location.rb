class Location
	include Mongoid::Document
	include Mongoid::Timestamps
	# Fields
	field :longitude, type: Float
	field :latitude, type: Float
	field :address, type: String
	field :zip, type: String # Storage space is cheap, reworking the database because of wierd zipcode rules in other countries is expensive
	
	# Relations
	belongs_to :rat_sighting
	belongs_to :borough, validate: false
	belongs_to :city, validate: false
	# Scoping and indexing
	scope :ordered, -> {order('created_at DESC')}


end
