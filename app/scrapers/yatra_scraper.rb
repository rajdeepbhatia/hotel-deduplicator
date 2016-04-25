class YatraScraper
  attr_accessor :page_path
  attr_reader :city

  def initialize(city_id=nil)
    @city = City.find(city_id)
    yatra_url = Domainatrix.parse(@city.yatra_url)
    self.page_path = yatra_url.path
  end

  def crawl_and_dump
    while page_path.present? do
      data = scrape_page
      self.page_path = data.delete('next_page')
      Hotel.process_and_save(data, { city: city.id, source: 'yatra' })
    end
  end

  private
  def scrape_page
    next_url = page_path

    Wombat.crawl do
      base_url "http://www.yatra.com"
      path next_url

      hotels "css=.res-info", :iterator do
        name 'css=aside h3 a'

        locality 'css=aside p' do |address|
          address.split(',').first
        end

        url({ xpath: ".//a[1]/@href" })
      end

      next_page({ xpath: '//a[starts-with(@class,"next")]/@href' }) do |link|
        link.gsub(/http:\/\/www.yatra.com/, '')
      end
    end
  end
end
