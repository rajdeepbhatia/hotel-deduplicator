class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :cleartrip_url
      t.string :yatra_url

      t.timestamps null: false
    end
  end
end
