Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '112974412105568', 'e09e71cc0b45031749a1e059d962cb99', :scope => "user_likes,user_birthday,offline_access"
end
