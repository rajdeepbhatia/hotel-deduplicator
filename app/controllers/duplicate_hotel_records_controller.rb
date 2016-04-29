class DuplicateHotelRecordsController < ApplicationController
  def create
    @record = DuplicateHotelRecord.where(duplicate_hotel_record_params).first_or_initialize
    @new_flag = @record.new_record?
    @record.save
  end

  def change_duplicate_status
    @record = DuplicateHotelRecord.find_by(id: params[:id])
    @record.toggle!(:is_duplicated)
    render json: { duplicate_status: @record.is_duplicated }
  end

  def de_duplicated_records
    @city = City.find_by(id: params[:city_id])
    @hotels = DuplicateHotelRecord.where(is_duplicated: true).
                select("duplicate_hotel_records.id, duplicate_hotel_records.cleartrip_hotel_id, duplicate_hotel_records.yatra_hotel_id, hotels.name AS cleartrip_name, hotels.locality AS cleartrip_locality, yatra_hotels.name AS yatra_name, yatra_hotels.locality AS yatra_locality").
                joins("INNER JOIN hotels ON duplicate_hotel_records.cleartrip_hotel_id = hotels.id").
                joins("INNER JOIN hotels AS yatra_hotels ON duplicate_hotel_records.yatra_hotel_id = yatra_hotels.id").
                paginate(page: params[:page], per_page: 5)
  end

  private
  def duplicate_hotel_record_params
    params.require(:duplicate_hotel_record).permit(:cleartrip_hotel_id, :yatra_hotel_id)
  end
end
