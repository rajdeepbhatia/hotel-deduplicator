class DuplicateWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(city_id=nil)
    city = City.find_by(id: city_id)

    unless city.blank?
      hotels = city.hotels
      cleartrip_hotels = hotels.where(source: 'cleartrip')
      yatra_hotels = hotels.where(source: 'yatra')

      cleartrip_hotels.each do |hotel|
        similar_hotels_ids = yatra_hotels.find_by_fuzzy_name(hotel.name).pluck(:id)
        DuplicateHotelRecord.create_records(hotel.id, similar_hotels_ids)
      end
    end
  end
end