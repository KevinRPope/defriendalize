class CanvasController < ApplicationController

  def index 
    if session[:user_id] && (session[:expire] > Time.now)
      @connections = Connection.where(:user_id => session[:user_id], :last_action => ['Canceled Account or Changed Privacy Settings', 'Reactivated Account', 'Defriended', 'Refriended', 'New Connection'], :updated_at => 30.days.ago.to_date..1.day.from_now.to_date).order('updated_at DESC').all
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
