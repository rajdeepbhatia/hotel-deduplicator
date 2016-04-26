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

  def self.process_and_save(hotels, extra_info={})
    processed_hotels = []
    hotels.each do |hotel|
      hotel = hotel.merge(extra_info)
      hotel = new(hotel)
      processed_hotels << hotel
    end
    import processed_hotels
  end

  def self.list_cleartrip_with_duplicate_records
    cleartrip.
      joins(:duplicate_yatra_records).
      select("hotels.*, hotels1.id as yatra_id, hotels1.name as yatra_name, hotels1.locality as yatra_locality, hotels1.source as yatra_source").
      joins("INNER JOIN hotels AS hotels1 ON duplicate_hotel_records.yatra_hotel_id = hotels1.id")
  end

  def self.list_yatra_with_duplicate_records
    yatra.
        joins(:duplicate_cleartrip_records).
        select("hotels.*, hotels1.id as cleartrip_id, hotels1.name as cleartrip_name, hotels1.locality as cleatrip_locality, hotels1.source as cleatrip_source").
        joins("INNER JOIN hotels AS hotels1 ON duplicate_hotel_records.cleartrip_hotel_id = hotels1.id")
  end
end
