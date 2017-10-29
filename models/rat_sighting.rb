class RatSighting
	include Mongoid::Document
	include Mongoid::Timestamps

	# Fields
	field :location_type
	field :ny_uid
	# Relations
	belongs_to :user, validate: false
	has_one :location

	# Scoping and indexing
	scope :ordered, -> {order('created_at DESC')}

  #This is a weird ruby idiom used to define class methods. It's kind of a short cut, but if you're interested ask me about it sometime

	class << self
		def paginate(opts = {})
			limit = (opts[:per_page] || 25).to_i
			page  = (opts[:page]  || 0).to_i
			
			offset = page * limit
			per_page(limit).offset(offset)
		end

		def per_page(page_limit = 25)
			ordered.limit(page_limit.to_i)
		end
	end
end
