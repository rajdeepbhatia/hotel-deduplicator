class DuplicateHotelRecordsController < ApplicationController
  def change_duplicate_status
    @record = DuplicateHotelRecord.find_by(id: params[:id])
    @record.toggle!(:is_duplicated)
    render json: { duplicate_status: @record.is_duplicated }
  end
end
