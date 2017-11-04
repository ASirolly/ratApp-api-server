module Queries
	@project = {
		'$project': {
			year:  { '$year':  '$created_at' },
			month: { '$month': '$created_at' }
		}
	}	

	@group = {
		'$group': {
			'_id': { year: '$year', month: '$month' },
			rat_sightings: { '$sum': 1 }
		}
	}
	
	def self.between_dates(start_date, end_date)
		{ '$match': { created_at: { '$gte': start_date, '$lte': end_date }}}
	end

	def self.frequency_between_dates(start_date, end_date)
		[between_dates(start_date, end_date), @project, @group]
	end
end
