class Hotel < ActiveRecord::Base
  URL_VALIDITY_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/
  scope :cleartrip, -> { where(source: 'cleartrip') }
  scope :yatra, -> { where(source: 'yatra') }

  validates :name, presence: true
  validates :locality, presence: true
  validates :url, presence: true, format: { with: URL_VALIDITY_REGEX, message: "Please enter a valid URL" }
  belongs_to :city
  has_many :duplicate_yatra_records, foreign_key: 'cleartrip_hotel_id', class_name: 'DuplicateHotelRecord'
  has_many :duplicate_cleartrip_records, foreign_key: 'yatra_hotel_id', class_name: 'DuplicateHotelRecord'

  fuzzily_searchable :name, :locality

  class << self
    def process_and_save(hotels, extra_info={})
      processed_hotels = []
      hotels.each do |hotel|
        hotel = hotel.merge(extra_info)
        hotel = new(hotel)
        processed_hotels << hotel
      end
      import processed_hotels
    end

    def list_cleartrip_with_duplicate_records(city_id)
      where(city_id: city_id).cleartrip.includes(:duplicate_yatra_records => :yatra_hotel)
    end

    def list_yatra_with_duplicate_records(city_id)
      where(city_id: city_id).yatra.includes(:duplicate_cleartrip_records => :cleartrip_hotel)
    end
  end
end
