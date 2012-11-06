class SessionController < ApplicationController
  protect_from_forgery :except => :deauthorize
  
  def create
#    raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"])
    Connection.facebook_fql(user, "{\"query2\":\"SELECT+url+from+url_like+WHERE+user_id=#{user.uid}\"}")
    Connection.facebook_fql(user, "{\"query2\":\"SELECT+url,type+from+object_url+WHERE+id+IN+(SELECT+object_id+from+like+where+user_id=#{user.uid})+AND+type=\'link\'+LIMIT+500\"}")
#    User.update_user_info(user, auth) 
#    Connection.test_post_to_page(user)
#    raise "hi there"
    if user
      User.update_user_info(user, auth)
      update_user_autoscale(user, auth)
      user_status = "existing"
    else
      user = User.create_with_omniauth(auth)
      MethodCallLog.log(user, "create_with_omniauth")
      new_user_autoscale(user, auth)
      user_status = "new"
    end
    #
    session[:user_id] = user.id
    session[:expire] = 1.day.from_now
    MethodCallLog.log(user, "login")    
    if session[:source] == "facebook"
        redirect_to canvas_index_path, :notice => "Signed in!"
    else
        redirect_to root_path, :notice => "Signed in!"
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
    if request.env["HTTP_REFERER"]
      (request.env["HTTP_REFERER"].include? "canvas") ? session[:source] = "facebook" : session[:source] = "web"
    else
      session[:source]="web"
    end
#    Autoscale.check_workers
    redirect_to "/auth/facebook"
  end
  
end
