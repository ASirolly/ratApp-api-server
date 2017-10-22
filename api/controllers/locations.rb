require 'date'
require "active_support/core_ext/integer/time" #dope ass library that allows the 1.day syntax

module API
	class LocationsController < Grape::API
		#Resourceful endpoint for locations
		resources :locations do
			desc "Gets the locations between two date ranges"
			params do
				optional :start_date, type: Date, default: Date.today - 7.days 
				optional :end_date, type: Date, default: Date.today + 1.day
				# Yeah you like that sexy ruby syntax, dont you?
			end

			get do
				if (params[:start_date] > params[:end_date])
					error 400, "Don't let your start date be after your end_date dummy - no records will ever get returned"
				else 
					@locations = Location.where(:created_at.gt => params[:start_date].to_datetime).where(																					 :created_at.lte => params[:end_date].to_datetime)
				end
			end
		end
	end
end
