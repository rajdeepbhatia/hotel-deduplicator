class AddColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :cleartrip_count, :integer, default: 0
    add_column :cities, :yatra_count, :integer, default: 0
    add_column :cities, :is_scraping, :boolean, default: true
  end
end
