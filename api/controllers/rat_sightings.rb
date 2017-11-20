require 'date'
require "active_support/core_ext/integer/time"
require 'json'

module API
	class RatSightingsController < Grape::API
		resources :rat_sightings do
			desc "Gets the {page}th set of {length} number of rat sightings"
			params do
				optional :page, default: 1 
				optional :per_page, default: 25
			end
			get do
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


			desc "Get sighting frequency per month between two dates"
			params do
				optional :start_date, default: (Date.today - 365).strftime("%d/%m/%Y")
				optional :end_date, default: Date.today.strftime("%d/%m/%Y")
			end
			get :frequency do
				start_date = Date.strptime(params[:start_date], "%d/%m/%Y")
			  end_date = Date.strptime(params[:end_date], "%d/%m/%Y")
				puts "start: #{start_date.strftime("%m %d, %y")}, end: #{end_date.strftime("%m %d, %y")}"
				aggregation = Queries::frequency_between_dates(start_date, end_date)
				sightings_per_month = RatSighting.collection.aggregate(aggregation).to_a
				return {data: sightings_per_month}
			end
		end


		desc "Gets rat sightings between two date ranges"
		params do
			optional :limit, default: 25
			# Default date range is past 30 days
			optional :start_date, default: (Date.today - 30).strftime("%d/%m/%Y")
			optional :end_date, default: Date.today.strftime("%d/%m/%Y")
		end
		get :rat_sightings_by_date do
			limit			 = params[:limit]
			start_date = Date.strptime(params[:start_date], "%d/%m/%Y").to_datetime
			end_date	 = Date.strptime(params[:end_date], "%d/%m/%Y").to_datetime
			if (start_date > end_date)
				error 400, "Start date is greater than end date - swap them first "
			else
				@sightings = RatSighting.between_dates(start_date, end_date).limit(limit)
				@sightings.as_json
			end
		end
	end
end
