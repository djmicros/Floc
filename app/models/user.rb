class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :country, :webpage, :provider, :fb_id, :avatar, :oauth_token, :oauth_expires_at
  has_secure_password
  has_many :locations, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, :if => :provider_not_fb?
  validates :password_confirmation, presence: true, :if => :provider_not_fb?
  validates_confirmation_of :password, :if => :provider_not_fb?
  validates :country, presence: true, :if => :provider_not_fb?
  

  def provider_not_fb?
      provider != "facebook"
  end

  def self.from_omniauth(auth)
	
	if User.find_by_email(auth.info.email) == nil
      @fb_user = User.new
	  @fb_user.id = User.last.id + 1
      @fb_user.provider = auth.provider
      @fb_user.fb_id = auth.uid
      @fb_user.name = auth.info.name
      @fb_user.email = auth.info.email
      @fb_user.avatar = auth.info.image
      @fb_user.webpage = auth.info.urls
      @fb_user.country = auth.info.location
      @fb_user.oauth_token = auth.credentials.token
      @fb_user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      if @fb_user.password_digest == nil 
      @fb_user.password_digest = "facebook"
      end 

		if @fb_user.save
		  @fb_user = user
		else
		  redirect_to sign_in
		end
	else
		@fb_user = User.find_by_email(auth.info.email)
	end

	  

  end


  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end