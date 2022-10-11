require "open-uri"
require "json"

p "Hi! Where are you located?"

user_location = gets.chomp

# user_location = "Taj Mahal"

p user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U"

/ look up ruby dig method / 

raw_data = URI.open(gmaps_url).read

parsed_data = JSON.parse(raw_data)

results =  parsed_data.fetch("results")
first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

p latitude
p longitude
