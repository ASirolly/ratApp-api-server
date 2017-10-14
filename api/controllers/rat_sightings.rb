module API
	class RatSightingsController < Grape::API

		resources :rat_sightings do
			desc "Gets the {page}th set of {length} number of rat sightings"
			params do
				use page: 1, per_page: 25
			end
			get do
				params[:page] ||= 1
				params[:per_page] ||= 25
				@rat_sightings = RatSighting.paginate(:page => params[:page].to_i - 1,
															:limit => params[:per_page].to_i).desc(:_id)
				@rat_sightings.as_json(methods: [:location])
			end
		end

	end
end
