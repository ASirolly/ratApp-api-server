require 'Date'
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
				@locations = Location.where(:created_at.gt => params[:start_date].to_datetime).where(																					 :created_at.lte => params[:end_date].to_datetime)
			end
		end
	end
end
