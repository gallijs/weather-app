require 'httpparty'
require 'debug'

API_KEY = 'bc1301b0b23fe6ef52032a7e5bb70820'
API_HOST = 'https://api.openweathermap.org'

# This module fetches forecast data from the Open Weather Map API
module WeatherAPI
  # Fetch the weather forecast by receiving a city name (:string)
  def self.fetch(city, units = 'imperial')
    raise "Missing string parameter for the city name." unless city

    params = {
      q: city,
      units: units,
      appid: API_KEY
    }
    response = HTTParty.get("#{API_HOST}/data/2.5/forecast", query: params)
    parsed = JSON.parse(response.body, object_class: OpenStruct)

    raise parsed["message"] if (response.code > 400)

    Forecast.new(units, parsed)
  end

  class Forecast
    # @return [String] Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    attr_reader :temperature_unit
    # @return [Array<WeatherConditions>] List of all weather conditions for the city.
    attr_reader :weather_conditions
    # @return [City] Information of the city with the forecast data
    attr_reader :city

    # @param tempurature_unit [String] Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    # @param response [OpenStruct] OpenWeatherMap API response for a forecast request
    def initialize(temperature_unit = 'imperial', response)
      @temperature_unit = temperature_unit
      @city = City.new(response.city)
      @weather_conditions = get_weather_conditions(response.list)
    end

    private

    # Instantiates a WeatherConditions class for each weather condition of the response
    def get_weather_conditions(list)
      list.map { |condition| WeatherConditions.new(condition)}
    end
  end

  class WeatherConditions
    # @return [String] A short description of the weather
    attr_reader :weather

    # @return [String] A detailed description of the weather
    attr_reader :description

    # @return [Float] Measurement of the average temperature
    attr_reader :temperature

    # @return [Float] Measure of how the temperature feels for a person
    attr_reader :feels_like

    # @return [Float] Lowest temperature measured
    attr_reader :temperature_low

    # @return [Float] Highest temperature measured
    attr_reader :temperature_high

    # @return [Float] Humidity percentage
    attr_reader :humidity

    # @return [Time] Weather time
    attr_reader :time

    # @return [String] Weather Date
    attr_reader :date

    # Create a new WeatherConditions object
    #
    # @param object [OpenStruct] A parsed weather object from OpenWeatherMap
    def initialize(object)
      @weather = object.dig(:weather, 0, :main)
      @description = object.dig(:weather, 0, :description)
      @temperature = object.dig(:main, :temp)
      @feels_like = object.dig(:main, :feels_like)
      @temperature_low = object.dig(:main, :temp_min)
      @temperature_high = object.dig(:main, :temp_max)
      @humidity = object.dig(:main, :humidity)
      @time = object[:dt]
      @date = object[:dt_txt]
    end
  end

  class City
    # @return [Float] Longitude
    attr_reader :lon

    # @return [Float] Latitude
    attr_reader :lat

    # @return [String] Location Name
    attr_reader :name

    # @return [String] Country
    attr_reader :country

    # Create a new City object
    #
    # @param city_object [OpenStruct] A city object from the OpenWeatherMap API response
    def initialize(city_object)
      @lon = city_object.coord.lon
      @lat = city_object.coord.lat
      @name = city_object.name
      @country = city_object.country
    end
  end
end
