class City < ActiveRecord::Base
  URL_VALIDITY_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :cleartrip_url, presence: true, format: { with: URL_VALIDITY_REGEX, message: "Please enter a valid URL" }
  validates :yatra_url, presence: true, format: { with: URL_VALIDITY_REGEX, message: "Please enter a valid URL" }
  validate :check_cleartrip_url
  validate :check_yatra_url

  has_many :hotels, dependent: :destroy
  has_many :cleartrip_hotels, -> { cleartrip }, class_name: 'Hotel'
  has_many :yatra_hotels, -> { yatra }, class_name: 'Hotel'

  def check_cleartrip_url
    url = Domainatrix.parse(cleartrip_url)
    domain = url.domain + '.' + url.public_suffix
    errors.add(:cleartrip_url, 'Please enter a valid cleartrip URL') unless domain == 'cleartrip.com'
  end

  def check_yatra_url
    url = Domainatrix.parse(yatra_url)
    domain = url.domain + '.' + url.public_suffix
    errors.add(:yatra_url, 'Please enter a valid Yatra URL') unless domain == 'yatra.com'
  end
end
