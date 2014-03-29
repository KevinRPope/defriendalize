# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Defriend::Application.config.secret_token = '8ee9f6b07eaaebf25c9d79e59bab36a50ba1e1b4929bafc5b41040076ce52f2c7f352990b5c6ebb3376d2ac87785bfe38dea37f133a77cce7b81aeba8f38d342'
Rails.application.config.middleware.use OmniAuth::Builder do
  if ENV["RAILS_ENV"] == "production"
    provider :facebook, '112974412105568', 'e09e71cc0b45031749a1e059d962cb99', :client_options => {:ssl => {:ca_file => '/curl-ca-bundle.crt'}} #, :scope => "user_likes,user_birthday,offline_access,publish_stream,user_education_history,user_location,user_relationships,user_groups,user_events,friends_groups,friends_events,friends_likes,friends_location,user_photos,friends_photos,user_videos,friends_videos,friends_relationship_details,user_religion_politics,friends_religion_politics,user_status,friends_status,read_stream,user_checkins,friends_checkins,friends_birthday,user_about_me,friends_about_me,user_activities,friends_activities,friends_education_history,user_hometown,friends_hometown"
  else
    provider :facebook, '205001809513746', '866d7ac10babe209068c881183d1ef8f',  :scope => "manage_pages,user_likes,user_birthday,offline_access,publish_stream,user_education_history,user_location,user_relationships,user_groups,user_events,friends_groups,friends_events,friends_likes,friends_location,user_photos,friends_photos,user_videos,friends_videos,friends_relationship_details,user_religion_politics,friends_religion_politics,user_status,friends_status,read_stream,user_checkins,friends_checkins,friends_birthday,user_about_me,friends_about_me,user_activities,friends_activities,friends_education_history,user_hometown,friends_hometown", :client_options => {:ssl => {:ca_file => '/usr/share/curl/curl-ca-bundle.crt'}}
  end
end