require 'heroku'

class DefriendController < ApplicationController
  def index
		
    if session[:user_id]
      if (session[:expire] > Time.now)
        @connections = Connection.where(:user_id => session[:user_id], :last_action => ['Defriended', 'Refriended', 'Canceled Account or Changed Privacy Settings', 'Reactivated Account', 'New Connection'], :updated_at => 30.days.ago.to_date..1.day.from_now.to_date).order('updated_at DESC').all
        @queued = Delayed_Job.where(["handler LIKE ?", "%uid: \"#{@user.uid}\"%"]).all.count
        update_connections
        #p Notifier.cron_test.deliver
      else
        session[:user_id] = nil
        flash[:warning] = "You have been logged out because it's been more than 24 hours since you last logged in"
      end
    end 
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def update_connections
    p conn = Connection.where(:updated_at => 7.days.ago.to_date..1.day.from_now.to_date).group(:user_id).select(:user_id).all
    conn.each do |u|
      user = User.find(u.user_id)
      MethodCallLog.log(user, "check_connections")
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
    if session[:user_id]
      @check = Delayed_Job.where(["handler LIKE ?", "%uid: \"#{@user.uid}\"%"]).all.empty?
    else
      @check = "logout"
    end
    render :layout => false
  end
  
  
end


