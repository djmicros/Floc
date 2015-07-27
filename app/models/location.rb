class Location < ActiveRecord::Base
  belongs_to :user
  #has_attached_file :photo #, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_many :photos, :dependent => :destroy
  
  attr_accessible :desc, :electricity, :geo, :name, :open, :public, :tag_list

  acts_as_taggable
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :desc, presence: true, length: { maximum: 200 }
  validates :geo, presence: true, uniqueness: true

end
