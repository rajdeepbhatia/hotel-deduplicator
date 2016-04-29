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

  private
  def duplicate_hotel_record_params
    params.require(:duplicate_hotel_record).permit(:cleartrip_hotel_id, :yatra_hotel_id)
  end
end
