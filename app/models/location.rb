class Location < ActiveRecord::Base
  belongs_to :user
  attr_accessible :desc, :electricity, :geo, :name, :open, :public
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :desc, presence: true, length: { maximum: 200 }
  validates :geo, presence: true, uniqueness: true

end
