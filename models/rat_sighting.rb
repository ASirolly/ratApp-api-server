class RatSighting
	include Mongoid::Document
	include Mongoid::Timestamps

	# Fields
	field :sighting_type
	# Relations
	embedded_in :user
	embeds_one :location, as: :locatable, validate: true

	# Scoping and indexing
	scope :ordered, -> {order('created_at DESC')}

	#validations
	validates :slug, presence: true, uniqueness: true


  #This is a weird ruby idiom used to define class methods. It's kind of a short cut, but if you're interested ask me about it sometime
	class << self
		def paginate(opts = {})
			limit = (opts[:per_page] || 25).to_i
			page  = (opts[:page]  || 1).to_i
			
			offset = 0
			offset = (page - 1) * limit unless page < 1
			per_page(limit).offset(offset)
		end

		def per_page(page_limit = 25)
			ordered.limit(page_limit.to_i)
		end
	end
end
