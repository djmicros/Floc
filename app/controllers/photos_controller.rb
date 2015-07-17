class PhotosController < ApplicationController

 def create
    @photo = Photo.new(params[:photo])
	@photo.description = "asdasdasd" #":rails_root/public/images/"+@photo.id+"/"+@photo.photo_file_name
    if @photo.save	  
      flash[:success] = "Photo added"
      redirect_to @location
    else
      render 'new'
    end
  end
  
  
  
  
end
