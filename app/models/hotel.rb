class Hotel < ActiveRecord::Base
  validates :name, presence: true
  validates :locality, presence: true
  belongs_to :city

  fuzzily_searchable :name, :locality, async: true
end
