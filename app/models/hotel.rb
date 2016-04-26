class Hotel < ActiveRecord::Base
  URL_VALIDITY_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/
  scope :cleartrip, -> { where(source: 'cleartrip') }
  scope :yatra, -> { where(source: 'yatra') }

  validates :name, presence: true
  validates :locality, presence: true
  validates :url, presence: true, format: { with: URL_VALIDITY_REGEX, message: "Please enter a valid URL" }
  belongs_to :city

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
end
