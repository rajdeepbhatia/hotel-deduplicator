class DumperWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(city_id=nil)
    city = City.where(id: city_id).first

    unless city.blank?
      cleartrip_scraper = CleartripScraper.new(city.id)
      cleartrip_scraper.crawl_and_dump
      yatra_scraper = YatraScraper.new(city.id)
      yatra_scraper.crawl_and_dump
    end
  end
end