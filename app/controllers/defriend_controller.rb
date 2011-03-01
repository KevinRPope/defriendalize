require 'heroku'

class DefriendController < ApplicationController
  def index
		
    if session[:user_id]
      if (session[:expire] > Time.now)
        if @user.uid == '1301244895'
          @connections = Connection.get_lulu(session[:user_id])
        else
          @connections = Connection.get_connections(session[:user_id])
        end
#        Connection.check_connections(User.find(session[:user_id]))
        @queued = Delayed_Job.where(["handler LIKE ?", "%uid: \"#{@user.uid}\"%"]).all.count
        @timing = MethodCallLog.where(:action => "check_connections", :updated_at => 3.hours.ago.to_time..Time.now.to_time).first.nil?
      else
        session[:user_id] = nil
        flash[:warning] = "You have been logged out because it's been more than 24 hours since you last logged in"
      end
    end 
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def check_my_connections
    Autoscale.check_workers
    Connection.delay.check_connections(User.find(session[:user_id]))
    Autoscale.check_worker_close
    redirect_to root_path
  end
  
  def update_connections
    p conn = Connection.where(:updated_at => 7.days.ago.to_date..1.day.from_now.to_date).group(:user_id).select(:user_id).all
    conn.each do |u|
      user = User.find(u.user_id)
      MethodCallLog.log(user, "check_connections")
    end
  end
  
  def friend_list_update
    if @user.uid == '1301244895'
      @connections = Connection.get_lulu(session[:user_id])
    else
      @connections = Connection.get_connections(session[:user_id])
    end
    @queued = 0
    @timing = MethodCallLog.where(:action => "check_connections", :updated_at => 3.hours.ago.to_time..Time.now.to_time).first.nil?
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


