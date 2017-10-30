require 'date'
require "active_support/core_ext/integer/time"

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
				@rat_sightings = RatSighting.paginate(:page => params[:page].to_i,
															:per_page => params[:per_page].to_i).desc(:_id)
				@rat_sightings.as_json
			end


			desc "Creates a new Rat Sighting"
			params do
				requires :longitude, :latitude, :city, :location_type, :borough, :address, :zip
			end
			post do
				city = City.where(name: params[:city]).first_or_create
				borough = Borough.where(name: params[:borough]).first_or_create
				location = Location.new(longitude: params[:longitude],
																latitude: params[:latitude],
																address: params[:address], zip: params[:zip],
																city: city, borough: borough)

				sighting = RatSighting.new(location_type: params[:location_type],
															location: location, user: User.first)

				if sighting.valid? && location.valid?
					sighting.save!
					location.save!
					city.save!
					borough.save!
					sighting.as_json
				else
					error!("Error Saving Sighting - make sure the parameters are correct", 422)
				end
			end
		end

		resources :rat_sightings_by_date do
			desc "Gets rat sightings between two date ranges"
			params do
				use limit: 25
			end

			get do
				params[:limit] ||= 25

				params[:start_date] = params[:start_date] ? Date.parse(params[:start_date], '%d/%m/%Y') : Date.today - 7.days
				params[:end_date] = params[:end_date] ? Date.parse(params[:end_date], '%d/%m/%Y') : Date.today + 1.days

				if (params[:start_date] > params[:end_date])
					error 400, "Don't let your start date be after your end_date dummy - no records will ever get returned"
				else
					@rat_sightings = RatSighting.where(:created_at.gt => params[:start_date].to_datetime).where(
						:created_at.lte => params[:end_date].to_datetime).limit(params[:limit])

					@rat_sightings.as_json
				end
			end
		end
	end
end
