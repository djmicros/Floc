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


def app_create
	if request.post?
		username = params[:username]
		token = params[:token]
			if User.find_by_email(username) != nil
				user = User.find_by_email(username)
					if user.remember_token == token
						@location = Location.new(params[:location])
						@location.user_id = user.id
						@location.name = params[:name]
						@location.desc = params[:desc]
						@location.geo = params[:geo]
						@location.tag_list = params[:tag_list]
						@location.electricity = params[:electricity]
						@location.open = params[:open]
						@location.public = params[:public]
						@location.latitude = params[:latitude]
						@location.longitude = params[:longitude]
						if @location.save
							response = "po zapisie"
							if params[:image1] != ""
									data = StringIO.new(Base64.decode64(params[:image1]))
									data.class.class_eval { attr_accessor :original_filename, :content_type }
									data.original_filename = "image1.jpg"
									data.content_type = "image/jpeg"
									if @location.photos.create(photo: data)
									response = "zapisano"
									else
									response = "gowno"
									end
							end
							if params[:image2] != ""
									data = StringIO.new(Base64.decode64(params[:image2]))
									data.class.class_eval { attr_accessor :original_filename, :content_type }
									data.original_filename = "image2.jpg"
									data.content_type = "image/jpeg"
									if @location.photos.create(photo: data)
									response = "zapisano"
									else
									response = "gowno"
									end
							end
							if params[:image3] != ""
									data = StringIO.new(Base64.decode64(params[:image3]))
									data.class.class_eval { attr_accessor :original_filename, :content_type }
									data.original_filename = "image3.jpg"
									data.content_type = "image/jpeg"
									if @location.photos.create(photo: data)
									response = "zapisano"
									else
									response = "gowno"
									end
							end
							response += "Location saved!"
							jsonresponse = response.to_json
							render :inline => jsonresponse
						else
							errors = "Errors: "
							@location.errors.full_messages.each do |msg| 
							errors = errors + msg + ", "
							render :inline => errors
							end
						end
					else
						render :inline => "wrong token"
					end
			else 
				render :inline => "wrong user"
			end
	else
		redirect_to signin_url, notice: "There is no place for you ;)"
	end
end

def app_search
	if request.post?
		if params[:search_tag].present? || params[:search_near].present? 
			if params[:search_tag] != ""
			@locations = Location.where('public = ?', true).tagged_with(params[:search_tag])
			else 
			@locations = Location
			end
			if params[:search_near] != ""
			@locations = @locations.near(params[:search_near], 10, :order => :distance)
			end
			@locations.each { |location|
				if location.photos.any?
					location[:photo] = request.base_url + location.photos.first.photo.url 
				end
			}
			if @locations.any?
				response = @locations
				jsonresponse = response.to_json
				render :inline => jsonresponse
			else 
				render :inline => "Unfortunately, no locations found"
			end
		else
			render :inline => "No search parameters specified"
		end
	else
		redirect_to signin_url, notice: "There is no place for you ;)"
	end
end

def app_get_location
	if request.post?
		if params[:id].present?
			@location = Location.find(params[:id])
			if @location.public == false
				if @location.user.email == params[:username] && @location.user.remember_token == params[:token]
					response = @location
					jsonresponse = response.to_json
					render :inline => jsonresponse
				else
					render :inline => "This is private location"
				end
			else
				response = @location
				jsonresponse = response.to_json
				render :inline => jsonresponse			
			end	
		else
			render :inline => "No id parameters specified"
		end
	else
		redirect_to signin_url, notice: "There is no place for you ;)"
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

def delete_photo
	@location = Location.find(params[:id])
		if @location.user == current_user
			@photo = Photo.find(params[:photo_id])
			@photo.destroy
			flash[:success] = "Photo deleted!"
			redirect_to edit_location_path(@location)
		else
			flash[:warning] = "It's not your location!"
			redirect_to locations_url
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
