class LocationsController < ApplicationController
before_filter :signed_in_user, only: [:index, :show, :edit, :new, :create, :update]
before_filter :correct_user,   only: [:edit, :update]
 
  def index

    if params[:search_tag].present? || params[:search_near].present? 
        if params[:search_tag].present?
          @locations = Location.where('public = ?', true).tagged_with(params[:search_tag]).paginate(page: params[:page])
  	    else 
          @locations = Location.paginate(page: params[:page])
  	    end
        if params[:search_near].present?
          @locations = @locations.near(params[:search_near], 10, :order => :distance)
        end
    else
        @locations = Location.where('public = ?', true).paginate(page: params[:page])
    end
  end
  
  def new
	@location = Location.new
  end
  
  def show
    @location = Location.find(params[:id])
    @hash = Gmaps4rails.build_markers(@location) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.picture({
           "url" => "/images/map_pin.png",
           "width" =>  40,
           "height" => 55})
        marker.infowindow location.geo + ".  " + location.desc
    end
  end
  
  def create
    @location = Location.new(params[:location])
	@location.user = current_user
	if @location.save
	      if params[:photos]
        params[:photos].each { |image|
          @location.photos.create(photo: image)
        }
      end
	  
      flash[:success] = "Location saved"
      redirect_to @location
    else
      render 'new'
    end
  end
  
  def edit
    @location = Location.find(params[:id])
  end
  
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
		  if params[:photos]
		params[:photos].each { |image|
          @location.photos.create(photo: image)
        }
      end
	  
      flash[:success] = "Location saved"
      redirect_to @location
    else
      render 'edit'
    end
  end
  
  def destroy
    @location = Location.find(params[:id])
		if @location.user == current_user
			@location.destroy
			flash[:success] = "Location destroyed."
			redirect_to locations_url
		else
			flash[:warning] = "It's not your location!"
			redirect_to @location
		end
  end
  
  def user_locations
    @user = User.find(params[:id])   
    if @user == current_user
      @locations = @user.locations.paginate(page: params[:page])
    else
      @locations = Location.where('public = ? AND user_id = ?', true, params[:id]).paginate(page: params[:page])
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
  
  def correct_user
      @user = Location.find(params[:id]).user
      redirect_to(root_path) unless current_user?(@user)
    end
  
  def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
  
  
  
end
