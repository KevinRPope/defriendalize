class SessionController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"]) 
    if user
      Connection.check_connections(user)
      Interest.check_interests(user)
    else
      user = User.create_with_omniauth(auth)
      Connection.create_connections(user)
      Interest.create_interests(user)
    end
    User.get_profile_pic(user) 
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
