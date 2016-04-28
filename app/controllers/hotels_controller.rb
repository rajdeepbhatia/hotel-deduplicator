class HotelsController < ApplicationController
  before_action :get_city

  def unmatched
    @hotels = Hotel.list_cleartrip_with_duplicate_records(@city.id).paginate(page: params[:page], per_page: 5)
  end

  private
  def get_city
    @city = City.find_by(id: params[:city_id])
    if @city.blank?
      flash[:error] = 'City not found.'
      redirect_to root_path
    end
  end
end
