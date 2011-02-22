Rails.application.config.middleware.use OmniAuth::Builder do
  if ENV["RAILS_ENV"] == "production"
    provider :facebook, '112974412105568', 'e09e71cc0b45031749a1e059d962cb99' #, :scope => "user_likes,user_birthday,offline_access,publish_stream,user_education_history,user_location,user_relationships"  #,user_groups,user_events,friends_groups,friends_events,friends_likes,friends_location,user_photos,friends_photos,user_videos,friends_videos,friends_relationship_details,user_religion_politics,friends_religion_politics,user_status,friends_status,read_stream,user_checkins,friends_checkins,friends_birthday,user_about_me,friends_about_me,user_activities,friends_activities,friends_education_history,user_hometown,friends_hometown"
  else
    provider :facebook, '205001809513746', '866d7ac10babe209068c881183d1ef8f' #, :scope => "user_likes,user_birthday,offline_access,publish_stream,user_education_history,user_location,user_relationships"  
  end
end