require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'GET /index' do
    let (:forecast) { JSON.parse(response.body, object_class: OpenStruct).forecast }

    context 'when the location is invalid' do
      it 'responds with 422' do
        get '/forecast', params: { forecast: { location: 'Unknown City' }}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when called with a city name' do
      it 'responds with forecast data for the city' do
        get '/forecast', params: { forecast: { location: 'Toronto' }}

        expect(response).to have_http_status(:success)
        expect(forecast.city.name).to eq("Toronto")
        expect(forecast.weather_conditions.length).to eq(7)
        expect(forecast.temperature_unit).to eq('imperial')
      end
    end

    context 'when called with metric units' do
      it 'responds with forecast data in that unit' do
        get '/forecast', params: { forecast: { location: 'Toronto', units: 'metric' }}

        expect(response).to have_http_status(:success)
        expect(forecast.weather_conditions.length).to eq(7)
        expect(forecast.temperature_unit).to eq('metric')
      end
    end
  end
end
