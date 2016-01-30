class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def create_fb
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    sign_in user
    redirect_back_or user
  end
  
  def app_create
	if request.post?
	username = params[:username]
	password = params[:password]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
				if user.authenticate(password)
					sign_in user
					response = user.name+" "+user.email+" "+user.remember_token
					jsonresponse = response.to_json
					render :inline => jsonresponse
				else
					render :inline => "false"
				end
		else
			render :inline => "false"
		end
	else
	redirect_to signin_url, notice: "There is no place for you ;)"
	end
	#render :nothing => true, :status => 500
  end
  
    def token_create
	if request.post?
	username = params[:username]
	token = params[:token]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
				if user.remember_token == token
					sign_in user
					response = user.name+" "+user.email+" "+user.remember_token

					#response[0] = user.name
					#response[1] = user.remember_token
					jsonresponse = response.to_json
					#jsonresponse = 
					render :inline => jsonresponse
				else
					render :inline => "false"
				end
		else
			render :inline => "false"
		end
	else
	redirect_to signin_url, notice: "There is no place for you ;)"
	end
	#render :nothing => true, :status => 500
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end