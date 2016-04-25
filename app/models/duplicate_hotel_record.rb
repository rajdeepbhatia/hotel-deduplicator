class DuplicateHotelRecord < ActiveRecord::Base

  def self.create_records(hotel_id, similar_hotels_ids=[])
    duplicate_records = []
    similar_hotels_ids.each do |duplicate_hotel_id|
      duplicate_records << new(cleartrip_hotel_id: hotel_id, yatra_hotel_id: duplicate_hotel_id)
    end
    import duplicate_records
  end
end