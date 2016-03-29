class Hotel < ActiveRecord::Base
  validates :name, presence: true
  validates :locality, presence: true

  belongs_to :city
end
