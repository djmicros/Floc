class LocationsController < ApplicationController

 
  def index
    @locations = Location.paginate(page: params[:page])
  end
  
  def new
	@location = Location.new
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def create
    @location = Location.new(params[:location])
	@location.user = current_user
	if @location.save
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
    if @location.update_attributes(params[:user])
      flash[:success] = "Location updated"
      redirect_to @location
    else
      render 'edit'
    end
  end
  
  def destroy
    Location.find(params[:id]).destroy
    flash[:success] = "Location destroyed."
    redirect_to users_url
  end
  
    def user_locations
	@id = :id
	@user = User.find(params[:id])
    @locations = @user.locations.paginate(:page => params[:page], :per_page => 30)
  end
  
  
  
  
end
