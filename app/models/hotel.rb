class Hotel < ActiveRecord::Base
  scope :cleartrip, -> { where(source: 'cleartrip') }
  scope :yatra, -> { where(source: 'yatra') }

  validates :name, presence: true
  validates :locality, presence: true
  belongs_to :city

  fuzzily_searchable :name, :locality, async: true

  def self.process_and_save(hotels, extra_info={})
    processed_hotels = []
    hotels.each do |hotel|
      hotel << extra_info
      hotel = new(hotel)
      processed_hotels << hotel
    end
    import processed_hotels
  end
end
