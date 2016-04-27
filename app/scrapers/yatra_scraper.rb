class YatraScraper
  attr_accessor :page_path
  attr_reader :city

  def initialize(city_id=nil)
    @city = City.find(city_id)
    yatra_url = Domainatrix.parse(@city.yatra_url)
    self.page_path = yatra_url.path
  end

  def crawl_and_dump
    while (page_path.present? and not page_path.include?('javascript:void')) do
      sleep(0.3) # added to avoid getting my ip blacklisted
      data = scrape_page
      self.page_path = data.delete('next_page')
      Hotel.process_and_save(data['hotels'], { city_id: city.id, source: 'yatra' })
    end
  end

  private
  def scrape_page
    next_url = page_path

    Wombat.crawl do
      base_url "http://www.yatra.com"
      path next_url

      hotels "css=article.yt-my-res", :iterator do
        name 'css=.result-details-wrapper .result-details-left .hotel-name a'

        locality 'css=.result-details-wrapper .result-details-left .hotel-location li' do |location|
          location.split(',').first unless location.blank?
        end

        url({ xpath: ".//a[1]/@href" })
      end

      next_page({ xpath: '//a[contains(@class,"next")]/@href' }) do |link|
        link.gsub(/http:\/\/www.yatra.com/, '') unless link.blank?
      end
    end
  end
end
