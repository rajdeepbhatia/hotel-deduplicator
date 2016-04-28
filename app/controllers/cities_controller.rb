class CitiesController < ApplicationController

  def index
    @city = City.new
    @cities = City.all.paginate(page: params[:page], per_page: 8)
  end

  def create
    @city = City.new(city_params)
    if @city.save
      DumperWorker.perform_async(@city.id)
      flash[:success] = 'City saved successfully, scraping in progress...'
    end
  end

  private
  def city_params
    params.require(:city).permit(:id, :name, :cleartrip_url, :yatra_url)
  end
end
