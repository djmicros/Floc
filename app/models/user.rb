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
    where(auth.slice(:provider, :fb_id)).first_or_initialize.tap do |user|
      user = User.new
	  user.id = auth.uid
      user.provider = auth.provider
      user.fb_id = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.avatar = auth.info.image
      user.webpage = auth.info.urls
      user.country = auth.info.location
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      if user.password_digest == nil 
      user.password_digest = "facebook"
      end 

    if user.save
      sign_in user
      flash[:success] = "Welcome to the Floc!"
      redirect_to user
    else
      render 'new'
    end


	  
    end
  end


  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end