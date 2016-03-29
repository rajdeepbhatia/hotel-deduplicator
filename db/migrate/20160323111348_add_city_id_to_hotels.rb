class AddCityIdToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :city_id, :integer
  end
end
