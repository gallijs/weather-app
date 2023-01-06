require 'weather_api'

describe "WeatherAPI" do
  let(:response) { JSON.parse(File.read("spec/fixtures/weather_response.json"), object_class: OpenStruct) }

  describe '.fetch' do
    context 'when called without arguments' do
      it 'responds with an error' do
        expect { WeatherAPI.fetch() }.to raise_error(ArgumentError)
      end
    end

    context 'when called with a location' do
      context 'when the location is nil' do
        it 'responds with an error' do
          expect { WeatherAPI.fetch(nil) }.to raise_error('Missing string parameter for the city name.')
        end
      end

      context 'when the location is not valid' do
        it 'responds with an error' do
          expect { WeatherAPI.fetch("Unknown City") }.to raise_error('city not found')
        end
      end
    end

    context 'when the location is valid' do
      it 'responds with weather for that location' do
        forecast = WeatherAPI.fetch("New York")

        expect(forecast.class).to eq(WeatherAPI::Forecast)
        expect(forecast.city.name).to eq("New York")
        expect(forecast.weather_conditions.length).to eq(40)
        expect(forecast.temperature_unit).to eq 'imperial'
      end
    end

    context 'when the unit is not default ' do
      it 'responds with forcast data in the specified unit' do
        forecast = WeatherAPI.fetch("New York", 'metric')

        expect(forecast.class).to eq(WeatherAPI::Forecast)
        expect(forecast.temperature_unit).to eq 'metric'
      end
    end
  end

  describe '::WeatherConditions' do
    it 'returns a WeatherConditions object with the normalized data' do
      weather_object = response.list[0]

      normalized = WeatherAPI::WeatherConditions.new(weather_object)
      expect(normalized.weather).to eq "Clouds"
      expect(normalized.description).to eq "overcast clouds"
      expect(normalized.time).to eq 1672963200
      expect(normalized.date).to eq "2023-01-06 00:00:00"
      expect(normalized.temperature).to eq 3.22
      expect(normalized.feels_like).to eq 1.35
      expect(normalized.temperature_low).to eq 3.21
      expect(normalized.temperature_high).to eq 3.22
      expect(normalized.humidity).to eq 83
    end
  end

  describe '::City' do
    it 'returns a City object with normalized data' do
      normalized = WeatherAPI::City.new(response.city)
      expect(normalized.lon).to eq(-79.4163)
      expect(normalized.lat).to eq(43.7001)
      expect(normalized.name).to eq('Toronto')
      expect(normalized.country).to eq('CA')
    end
  end

  describe '::Forecast' do
    it 'return a Forecast object with normalized data' do
      forecast = WeatherAPI::Forecast.new(response)
      expect(forecast.temperature_unit).to eq('imperial')
      expect(forecast.city.class).to eq(WeatherAPI::City)
      expect(forecast.weather_conditions.class).to eq(Array)
      expect(forecast.weather_conditions.length).to eq(40)
      expect(forecast.weather_conditions[0].class).to eq(WeatherAPI::WeatherConditions)
    end
  end
end
