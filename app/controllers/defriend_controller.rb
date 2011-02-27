require 'heroku'

class DefriendController < ApplicationController
  def index
		
    if session[:user_id]
      if (session[:expire] > Time.now)
        Connection.delay.check_connections(@user)
        @connections = Connection.where(:user_id => session[:user_id], :last_action => ['Defriended', 'Refriended', 'Canceled Account or Changed Privacy Settings', 'Reactivated Account', 'New Connection'], :updated_at => 30.days.ago.to_date..1.day.from_now.to_date).order('updated_at DESC').all
        p @queued = Delayed_Job.where(["handler LIKE ?", "%uid: \"#{@user.uid}\"%"]).all.count
      else
        session[:user_id] = nil
        flash[:warning] = "You have been logged out because it's been more than 24 hours since you last logged in"
      end
    end 
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def friend_list_update
    @connections = Connection.where(:user_id => session[:user_id], :last_action => ['Defriended', 'Refriended', 'Canceled Account or Changed Privacy Settings', 'Reactivated Account', 'New Connection'], :updated_at => 30.days.ago.to_date..1.day.from_now.to_date).order('updated_at DESC').all
    @queued = 0
    respond_to do |format|
      format.js
    end
  end
  
  def update_checkin
    @check = Delayed_Job.where(["handler LIKE ?", "%uid: \"#{@user.uid}\"%"]).all.empty?
    render :layout => false
  end
end


