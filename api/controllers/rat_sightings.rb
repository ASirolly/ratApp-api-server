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

				@rat_sightings.as_json({without: :location_id, :include => { :location => { :include => [:borough, :city], without:  :city_id }}})
			end


			desc "Creates a new Rat Sighting"
			params do
				requires :longitude, :latitude, :city, :location_type, :borough, :address, :zip
			end
			post do
				city = City.find_or_create_by(name: params[:city])
				borough = Borough.find_or_create_by(name: params[:borough])
				location = Location.new(longitude: params[:longitude],
																latitude: params[:latitude],
																address: params[:address], zip: params[:zip],
																city: city, borough: borough)

				sighting = RatSighting.new(location_type: params[:location_type],
															location: location, user: current_user)

				puts sighting.valid?
				if sighting.valid? && location.valid?
					sighting.save!
					location.save!
					city.save!
					borough.save!
					sighting
				else
					error!("Error Saving Sighting - make sure the parameters are correct", 422)
				end
			end
		end

	end
end
