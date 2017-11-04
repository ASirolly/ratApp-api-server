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
	scope :between_dates, ->(start_date, end_date){before(end_date).after(start_date)}
	scope :before, -> (date){where(:created_at.lte => date)}
	scope :after, -> (date){where(:created_at.gte => date)}

	def as_json(options = {})
		loc_options = { :include => [:borough, :city], without:  [:city_id, :borough_id, :rat_sighting_id]}

		defaults = {without: :location_id, :include =>
																		 { :location => loc_options}}

		options = options.merge(defaults) unless options.include?(:truncated)
		super(options)
	end


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
