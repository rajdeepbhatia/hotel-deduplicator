class HotelSerializer < ActiveModel::Serializer
  attributes :id, :label, :value, :source, :duplicate_hotel_id

  def label
    "#{object.name}, #{object.locality}"
  end

  def value
    object.name
  end

  def duplicate_hotel_id
    serialization_options[:duplicate_hotel_id]
  end
end