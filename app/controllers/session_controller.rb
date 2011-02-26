class SessionController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml
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
    p "source: " + session[:source].to_s
    session[:user_id] = user.id
    session[:expire] = 1.day.from_now
    if session[:source] == "facebook"
      redirect_to canvas_index_path, :notice => "Signed in!"
    else
      redirect_to root_path, :notice => "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:expire] = 1.day.ago
    if session[:source] == "facebook"
      redirect_to canvas_index_path, :notice => "Signed out!"
    else
      redirect_to root_path, :notice => "Signed out!"
    end  end
  
  def facebook_destroy
    session[:user_id] = nil
    session[:expire] = 1.day.ago
    if session[:source] == "facebook"
      redirect_to "http://m.facebook.com/logout.php?confirm=1&next=http://www.defriendalize.com/canvas"
    else
      redirect_to "http://m.facebook.com/logout.php?confirm=1&next=http://www.defriendalize.com"
    end
  end

  def FAQ
  end
  
  def about_us
  end
  
  def contact_us
  end
  
  def privacy_policy
  end
  
  def facebook_login
    (request.env["HTTP_REFERER"].include? "canvas") ? session[:source] = "facebook" : session[:source] = "web"
    Autoscale.check_workers
    redirect_to "/auth/facebook"
  end
  
end
