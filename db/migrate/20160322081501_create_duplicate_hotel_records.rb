class CreateDuplicateHotelRecords < ActiveRecord::Migration
  def change
    create_table :duplicate_hotel_records do |t|
      t.integer :cleartrip_hotel_id
      t.integer :yatra_hotel_id
      t.string :reason

      t.timestamps null: false
    end
  end
end
