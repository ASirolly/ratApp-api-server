require 'grape'
require 'mongoid'
require 'pry'
require 'CSV'

ENV["MONGOID_ENV"] = "development"

Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../api/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../config/**/*.rb"].each {|f| require f}

Mongoid.load! "../config/mongoid.config"
headers = []


if User.all.length == 0
	User.create(email: "ratapp.admin@testing.co",
						  first_name: "admin", password: "password", admin: true)
end

def store(data = {})
	loc_data = {longitude: data[:longitude], latitude: data[:latitude],
								address: data[:incident_address], zip: data[:incident_zip]}
	borough_info = {name: data[:borough]}
	city_info = {name: data[:city]}
	sighting_info = {ny_uid: data[:unique_key], location_type: data[:location_type]}

	sighting_info[:created_at] = Date.strptime(data[:created_date], "%m/%d/%Y %I:%M:%S %p")

	loc_data[:borough] = Borough.find_or_create_by(borough_info)
	loc_data[:city] = City.find_or_create_by(city_info)

	location = Location.new(loc_data)
	sighting_info[:location] = location
	sighting_info[:user] = User.first

	sighting = RatSighting.new(sighting_info)
	sighting.save!
	location.save!
	puts sighting.as_json
	puts location.as_json
	puts "#{RatSighting.all.length} RatSightings exist"
end

City.create(name: "brooklyn")
puts "city created, no problem"

CSV.open('./rat_sightings.csv', 'r') do |csv|
	#define headers and rewrite them in a way that is easy for our models to interact with
	headers = csv.first
	headers.map! {|header| (header.downcase.gsub(" ", "_")).to_sym unless header.nil? }

	#read the actual data
	#csv.readlines[30583..-1].each do |row|
	csv.readlines[200..-1].each do |row|
		#some fancy ass lambda stuff
		data = row.each_with_object({}).with_index do |(value, hash), index| 
			hash[headers[index]] = value
		end

		store(data)
	end
end

