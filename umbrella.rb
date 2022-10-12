require "open-uri"
require "json"


p "Hi! Where are you located?"

user_location = gets.chomp

# user_location = "Taj Mahal"

# p user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_TOKEN")}"

#ruby dig method

raw_data = URI.open(gmaps_url).read

parsed_data = JSON.parse(raw_data)

results =  parsed_data.fetch("results")
first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

lat_long = "#{latitude},#{longitude}"

dark_sky_url = "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_TOKEN")}/#{lat_long}"

raw_weather_data = URI.open(dark_sky_url).read

parsed_weather_data = JSON.parse(raw_weather_data)

current_weather = parsed_weather_data.fetch("currently")
current_summary = current_weather.fetch("summary")
current_temp = current_weather.fetch("temperature")


p "Your coordinates are #{latitude}, #{longitude}"
p "It is currently #{current_temp}°F."

minutely = parsed_weather_data.fetch("minutely", false)

if minutely
  next_hour = minutely.fetch("summary")
  p "Next hour: #{next_hour}"
end

hourly_weather = parsed_weather_data.fetch("hourly")
hourly_data = hourly_weather.fetch("data")

next_twelve_hours = hourly_data[1..12]

precipitation_threshold = 0.1
precipitation = false

next_twelve_hours.each do |hourly|
  rain_prob = hourly.fetch("precipProbability")

  if rain_prob > precipitation_threshold

    precip_time = Time.at(hourly.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    p "In #{hours_from_now.round} hours, there is a #{(hourly.fetch("precipProbability")*100).round}% chance of precipitation."
    precipitation = true
  end
end

if precipitation
  puts "You might want to take an umbrella!"
else 
  puts "You probably won't need an umbrella"
end


# p dark_sky_url

# use 
