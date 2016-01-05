class Location < ActiveRecord::Base
  belongs_to :user
  #has_attached_file :photo #, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_many :photos, :dependent => :destroy

  reverse_geocoded_by :latitude, :longitude
  #geocoded_by :geo
  #after_validation :geocode, :if => :geo_changed?
  #reverse_geocoded_by :latitude, :longitude, :geo => :location
  #after_validation :reverse_geocode

  attr_accessible :desc, :electricity, :geo, :name, :open, :public, :tag_list, :latitude, :longitude

  acts_as_taggable
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :desc, presence: true, length: { maximum: 200 }
  validates :geo, presence: true, uniqueness: true



end
