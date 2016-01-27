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
