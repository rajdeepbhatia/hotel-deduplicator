class DuplicateWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(city_id=nil)
    city = City.where(id: city_id).first

    unless city.blank?

    end
  end
end