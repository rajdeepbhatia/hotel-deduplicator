class HotelsController < ApplicationController
  def index
    @hotels = Hotel.list_cleartrip_with_duplicate_records
  end
end
