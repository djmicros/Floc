Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "170855049939026", "d6905539430664d240f7d8497861ca77",
		   :scope => 'email',
           :display => 'popup'
end