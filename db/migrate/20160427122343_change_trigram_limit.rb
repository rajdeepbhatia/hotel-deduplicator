class ChangeTrigramLimit < ActiveRecord::Migration
  def change
    change_column :trigrams, :trigram, :string, limit: 4
  end
end
