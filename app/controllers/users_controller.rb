class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
 
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
	@user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
	country = ISO3166::Country.new(@user.country)
	@user.country = country.name
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def app_create
	if request.post?
		@user = User.new(params[:user])
		@user.name = params[:name]
		@user.country = params[:country]
		@user.email = params[:email]
		@user.webpage = params[:webpage]
		@user.password = params[:password]
		@user.password_confirmation = params[:password_confirmation]
		if @user.save
					response = @user.name+" "+@user.email+" "+@user.remember_token
					jsonresponse = response.to_json
					render :inline => jsonresponse
		else
		errors = "Errors: "
		@user.errors.full_messages.each do |msg| 
		errors = errors + msg + ", "
		end
		render :inline => errors
		end
	else
		redirect_to signin_url, notice: "There is no place for you ;)"
	end
  end
	
  def app_get_user_locations
	if request.post?
		username = params[:username]
		token = params[:token]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
			if user.remember_token == token
				locations = user.locations
				locations.each { |location|
				if location.photos.any?
					location[:photo] = location.photos.first.photo.url 
				end
			}
			if locations.any?
				response = locations
				jsonresponse = response.to_json
				render :inline => jsonresponse
			else 
				render :inline => "Unfortunately, no locations found"
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
  
def app_get_user
	if request.post?
		username = params[:username]
		token = params[:token]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
			if user.remember_token == token
				jsonresponse = user.to_json
				render :inline => jsonresponse
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
  

def app_update_user
	if request.post?
		username = params[:username]
		token = params[:token]
		password = params[:password]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
			if user.remember_token == token
				if user.authenticate(password)
					if user.update_attributes(:name => params[:name], :country => params[:country], :webpage => params[:webpage], :password => params[:password], :password_confirmation => params[:password], :email => params[:username])
					  render :inline => user.remember_token
					else
					  render :inline => "fail updatu"
					end
				else
					render :inline => "fail logowania haslem"
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
  
  
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  
  
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
	
	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
	
	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
