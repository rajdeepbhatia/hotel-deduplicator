class CitiesController < ApplicationController

  def index
    @city = City.new
    @cities = City.all
  end

  def create
    @city = City.new(city_params)
    if @city.save
      DumperWorker.perform_async(@city.id)
      redirect_to cities_path
    else

    end
  end

  private
  def city_params
    params.require(:city).permit(:id, :name, :cleartrip_url, :yatra_url)
  end
end
