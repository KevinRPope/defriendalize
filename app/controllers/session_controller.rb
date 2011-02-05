class SessionController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"]) 
    if user
      User.update_user_info(user, auth)
#      Autoscale.update_user_autoscale(user, auth)
    else
      user = User.create_with_omniauth(auth)
      Autoscale.new_user_autoscale(user, auth)
    end
    #
    session[:user_id] = user.id
    redirect_to root_path, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out!"
  end
  
  def facebook_destroy
    session[:user_id] = nil
    redirect_to "http://m.facebook.com/logout.php?confirm=1&next=http://empty-journey-469.heroku.com"
  end

  def FAQ
    
  end

end
