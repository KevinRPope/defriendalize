require 'autoscale'
require 'heroku'
class DefriendController < ApplicationController
  def index
    p @@heroku.info('empty-journey-469')
    #Autoscale.delay(:run_at => 5.minutes.from_now).testerama
    if session[:user_id]
      #Connection.profile_pic(User.find(session[:user_id]))
      
      @connections = Connection.where(:user_id => @user.id, :last_action => ['cancelled', 'defriend', 'new']).order('updated_at DESC').limit(10).all
    end
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
