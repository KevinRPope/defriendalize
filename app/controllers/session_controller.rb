class SessionController < ApplicationController
  protect_from_forgery :except => :deauthorize
  
  def create
    #raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"]) 
    if user
      User.update_user_info(user, auth)
      Autoscale.update_user_autoscale(user, auth)
      user_status = "existing"
    else
      user = User.create_with_omniauth(auth)
      MethodCallLog.log(user, "create_with_omniauth")
      Autoscale.new_user_autoscale(user, auth)
      user_status = "new"
    end
    #
    session[:user_id] = user.id
    session[:expire] = 1.day.from_now
    MethodCallLog.log(user, "login")    
    if session[:source] == "facebook"
#      if user_status == "new"
#        redirect_to "http://www.facebook.com/dialog/feed?app_id="+auth["credentials"]["token"].to_s.split("|")[0]+"&link=http://apps.facebook.com/defriendalize/&picture=http://www.defriendalize.com/images/flash-check.png&name=Defriendalize.com&caption=Track%20Your%20Friend%20List&description=Keep%20track%20of%20who%20defriends%20you%20and%20who%20has%20canceled%20their%20account.%20%20I'm%20watching%20you,%20grandma!&redirect_uri=http://www.defriendalize.com/canvas", :notice => "Signed in!"
#      else
        redirect_to canvas_index_path, :notice => "Signed in!"
#      end
    else
#      if user_status == "new"
#        redirect_to "http://www.facebook.com/dialog/feed?app_id="+auth["credentials"]["token"].to_s.split("|")[0]+"&link=http://www.defriendalize.com/&picture=http://www.defriendalize.com/images/flash-check.png&name=Defriendalize.com&caption=Track%20Your%20Friend%20List&description=Keep%20track%20of%20who%20defriends%20you%20and%20who%20has%20canceled%20their%20account.%20%20I'm%20watching%20you,%20grandma!&redirect_uri=http://www.defriendalize.com/", :notice => "Signed in!"
#      else
        redirect_to root_path, :notice => "Signed in!"
#      end
    end
  end

  def destroy
    MethodCallLog.log(@user, "destroy_session")
    session[:user_id] = nil
    session[:expire] = 1.day.ago
    if session[:source] == "facebook"
      redirect_to canvas_index_path, :notice => "Signed out!"
    else
      redirect_to root_path, :notice => "Signed out!"
    end
  end
  
  def facebook_destroy
    MethodCallLog.log(@user, "facebook_destroy")
    session[:user_id] = nil
    session[:expire] = 1.day.ago
    if session[:source] == "facebook"
      redirect_to "http://m.facebook.com/logout.php?confirm=1&next=http://www.defriendalize.com/canvas"
    else
      redirect_to "http://m.facebook.com/logout.php?confirm=1&next=http://www.defriendalize.com"
    end
    
  end
  
  def deauthorize
    MethodCallLog.log(@user, "deauthorize")
    hash, encoded_token = params[:signed_request].split('.')
    encoded_token += '=' * (4 - encoded_token.length.modulo(4))
    @cipher_token = ActiveSupport::JSON.decode(Base64.decode64(encoded_token.tr('-_','+/')))
    @user = User.find_by_uid(@cipher_token["user_id"])
    @user.email_me = false
    @user.access_token = nil
    @user.save
    head :ok   
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
