class DuplicateWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(city_id=nil)
    city = City.find_by(id: city_id)

    unless city.blank?
      hotels = city.hotels
      cleartrip_hotels = hotels.where(source: 'cleartrip')
      cleartrip_hotels.each do |hotel|
        search_term = hotel.name.gsub(/Hotel|hotel|The|the|Inn|inn|palace|Palace|international|International|#{city.name}|Residency|residency|regency|Regency| /, '')
        similar_hotels = Hotel.find_by_fuzzy_name(search_term, limit: 2)
        similar_yatra_hotels_ids = similar_hotels.select{ |hotel| hotel.source == 'yatra' }.map(&:id)
        DuplicateHotelRecord.create_records(hotel.id, city.id, similar_yatra_hotels_ids)
      end
      city.update(is_scraping: false)
    end
  end
end