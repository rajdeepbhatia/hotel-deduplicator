class AddCityIdToDuplicateHotelRecords < ActiveRecord::Migration
  def change
    add_column :duplicate_hotel_records, :city_id, :integer
  end
end
