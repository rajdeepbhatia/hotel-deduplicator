class AddIsDuplicatedToDuplicateHotelRecords < ActiveRecord::Migration
  def change
    add_column :duplicate_hotel_records, :is_duplicated, :boolean, default: false
  end
end
