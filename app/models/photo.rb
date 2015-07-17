class Photo < ActiveRecord::Base

  belongs_to :location

  attr_accessible :photo
  
  has_attached_file :photo,
    :path => ":rails_root/public/images/:id/:filename", 
    :url  => "/images/:id/:filename"
	

  #do_not_validate_attachment_file_type :photo
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end