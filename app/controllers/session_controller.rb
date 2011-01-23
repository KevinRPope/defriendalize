class SessionController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"]) 
    if user
      #Connection.delay.check_connections(user)
      #Interest.delay.check_interests(user)
    else
      user = User.create_with_omniauth(auth)
      #Connection.delay.create_connections(user)
      #Education.delay.create_education(user, auth)
      #Interest.delay.create_interests(user)
    end
    #User.delay.get_profile_pic(user) 
    session[:user_id] = user.id
    redirect_to root_path, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out!"
  end

  def FAQ
    
  end

end
