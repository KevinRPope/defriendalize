require 'heroku'

class DefriendController < ApplicationController
  def index
    #p @@heroku.info(APP_NAME)
    #Autoscale.update_user_autoscale(User.find(1))
    if session[:user_id]
      #Connection.profile_pic(User.find(session[:user_id]))
      @connections = Connection.where(:user_id => @user.id, :last_action => ['cancelled', 'defriend', 'new'], :updated_at => 30.days.ago.to_date..Time.now.to_date).order('updated_at DESC').limit(10).all
    end
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
