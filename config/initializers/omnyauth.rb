Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  
  provider :facebook, "1088007531295417", "d003c28075ef8d399e06bc46b9f838d4",
    scope: 'public_profile', info_fields: 'id,name,link'

end