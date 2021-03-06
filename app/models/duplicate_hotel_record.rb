class DuplicateHotelRecord < ActiveRecord::Base
  validates :cleartrip_hotel_id, uniqueness: { scope: :yatra_hotel_id }
  belongs_to :cleartrip_hotel, foreign_key: 'cleartrip_hotel_id', class_name: 'Hotel'
  belongs_to :yatra_hotel, foreign_key: 'yatra_hotel_id', class_name: 'Hotel'

  def self.create_records(hotel_id, city_id, similar_hotels_ids=[])
    duplicate_records = []
    similar_hotels_ids.each do |duplicate_hotel_id|
      duplicate_records << new(cleartrip_hotel_id: hotel_id, yatra_hotel_id: duplicate_hotel_id, city_id: city_id)
    end
    import duplicate_records
  end
end