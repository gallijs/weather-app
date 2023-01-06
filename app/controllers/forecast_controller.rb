class ForecastController < ApplicationController
  def index
    begin
      @forecast = WeatherAPI.fetch(
        forecast_params.fetch(:location, nil),
        forecast_params.fetch(:units, 'imperial'))

      return render json: { forecast: @forecast }
    rescue => e
      logger.error e
      return render json: { message: "An error occurred while fetching the forecast." }, status: :unprocessable_entity
    end
  end

  private

  def forecast_params
    params.require(:forecast).permit(:location, :units);
  end
end
