class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :locality
      t.string :source
      t.string :url

      t.timestamps null: false
    end
  end
end
