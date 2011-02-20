class SessionController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml
    p request.env["HTTP_REFERER"]
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"]) 
    if user
      User.update_user_info(user, auth)
      Autoscale.update_user_autoscale(user, auth)
    else
      user = User.create_with_omniauth(auth)
      Autoscale.new_user_autoscale(user, auth)
    end
    #
    session[:user_id] = user.id
    session[:expire] = 1.day.from_now
    redirect_to root_path, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    session[:expire] = 1.day.ago
    redirect_to root_path, :notice => "Signed out!"
  end
  
  def facebook_destroy
    session[:user_id] = nil
    session[:expire] = 1.day.ago
    redirect_to "http://m.facebook.com/logout.php?confirm=1&next=http://empty-journey-469.heroku.com"
  end

  def FAQ
  end
  
  def about_us
  end
  
  def contact_us
  end
  
  def privacy_policy
  end
  
end
