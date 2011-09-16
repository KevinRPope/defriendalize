ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'gmail.com',
  :authentication => 'plain',
  :user_name => 'no-reply@defriendalize.com',
  :password => 's25BTQ37z'
}
#if ENV["RAILS_ENV"] == 'development'
#  ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#elsif ENV["RAILS_ENV"] == 'production'
  ActionMailer::Base.default_url_options[:host] = "defriendalize.com"
#end

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default :charset => "utf-8"
 
ActionMailer::Base.raise_delivery_errors = true