class CanvasController < ApplicationController

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
  end

  def faq 
  end
  
  def privacy 
  end
  
  def about_us 
  end
  
  def contact_us 
  end
  
  def profile 
    @user = User.find(session[:user_id])
    @friend_count = Connection.where(:last_action => [:new, :create]).find_all_by_user_id(session[:user_id]).count
  end

end
