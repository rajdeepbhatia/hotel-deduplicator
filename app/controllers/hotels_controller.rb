class HotelsController < ApplicationController
  before_action :get_city, only: [:unmatched]

  def unmatched
    @hotels = unless params[:source] == 'yatra'
                Hotel.list_cleartrip_with_duplicate_records(@city.id).paginate(page: params[:page], per_page: 5)
              else
                Hotel.list_yatra_with_duplicate_records(@city.id).paginate(page: params[:page], per_page: 5)
              end
  end

  def search
    hotels = Hotel.where("city_id = ? AND source = ? AND lower(name) like lower(?)", params[:city_id], params[:source], "%#{params[:term]}%")
    hotel_serializer = ActiveModel::ArraySerializer.new(hotels, each_serializer: HotelSerializer)
    render json: hotel_serializer, duplicate_hotel_id: params[:hotel_id]
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
