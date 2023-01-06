class ForecastController < ApplicationController
  def index
    begin
      $redis = Redis.new

      # Return the cached result
      if $redis.exists?(params_key)
        cached = JSON.parse($redis.get(params_key))
        return render json: { forecast: cached, cached: true }
      end

      @forecast = WeatherAPI.fetch(
        forecast_params.fetch(:location, nil),
        forecast_params.fetch(:units, 'imperial'))

      # Create cache and store for 30 min
      $redis.set(params_key, @forecast.to_json, ex: 1800)

      return render json: { forecast: @forecast, cached: false }
    rescue => e
      logger.error e
      return render json: { message: "An error occurred while fetching the forecast." }, status: :unprocessable_entity
    end
  end

  private

  # Create unique key from the params
  def params_key
    forecast_params.to_json
  end

  def forecast_params
    params.require(:forecast).permit(:location, :units);
  end
end
