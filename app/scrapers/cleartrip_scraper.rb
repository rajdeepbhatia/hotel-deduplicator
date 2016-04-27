class CleartripScraper
  attr_accessor :page_path
  attr_reader :city

  def initialize(city_id=nil)
    @city = City.find(city_id)
    cleartrip_url = Domainatrix.parse(@city.cleartrip_url)
    self.page_path = cleartrip_url.path
  end

  def crawl_and_dump
    while page_path.present? do
      sleep(0.3) # added to avoid getting my ip blacklisted
      data = scrape_page
      self.page_path = data.delete('next_page')
      Hotel.process_and_save(data['hotels'], { city_id: city.id, source: 'cleartrip' })
    end
  end

  private
  def scrape_page
    next_url = page_path

    Wombat.crawl do
      base_url "http://www.cleartrip.com"
      path next_url

      hotels "css=div.hotelMainInfo", :iterator do
        name 'css=h3 a'

        locality 'css=p.hotelLocality' do |address|
          address.gsub(/\t|\n|Map:| /, '')
        end

        url({ xpath: ".//a[1]/@href" }) do |link|
          "http://www.cleartrip.com#{link}"
        end
      end

      next_page({ xpath: '//*[@class="next"]/a[1]/@href' })
    end
  end
end