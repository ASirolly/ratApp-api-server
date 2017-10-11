require 'grape'
require 'mongoid'
require 'pry'
require 'CSV'

ENV["RACK_ENV"] = "development"

Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../api/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../config/**/*.rb"].each {|f| require f}

Mongoid.load! "../config/mongoid.config"
headers = []

class Report
  def initialize(data = {})
		loc_data = {longitude: data[:longitude], latitude: data[:latitude],
									address: data[:incident_address], zip: data[:incident_zip]}
		borough_info = {name: data[:borough]}
		city_info = {name: data[:city]}
		sighting_info = {ny_uid: data[:ny_uid], location_type: data[:location_type]}
	
		loc_data[:borough] = Borough.find_or_create_by(borough_info)
		loc_data[:city] = City.find_or_create_by(city_info)
		puts "made it here"
		location = Location.create(loc_data)
		sighting_info[:location] = location
		sighting_info[:user] = User.first
		rat_sighting = RatSighting.create(sighting_info)
		puts rat_sighting.as_json
  end
end

City.create(name: "brooklyn")
puts "city created, no problem"

CSV.open('./Rat_Sightings.csv', 'r') do |csv| 
	#define headers and rewrite them in a way that is easy for our models to interact with
	headers = csv.first
	headers.map! {|header| (header.downcase.gsub(" ", "_")).to_sym unless header.nil? }

	#read the actual data
	csv.readlines[1..-1].each do |row|
		#some fancy ass lambda stuff
		data = row.each_with_object({}).with_index do |(value, hash), index| 
			hash[headers[index]] = value
		end

		Report.new(data)
	end
end
