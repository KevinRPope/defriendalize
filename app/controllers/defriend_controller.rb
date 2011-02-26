require 'heroku'

class DefriendController < ApplicationController
  def index
		
    if session[:user_id]
      if (session[:expire] > Time.now)
        @connections = Connection.where(:user_id => session[:user_id], :last_action => ['Defriended', 'Refriended', 'Canceled Account or Changed Privacy Settings', 'Reactivated Account', 'New Connection'], :updated_at => 30.days.ago.to_date..1.day.from_now.to_date).order('updated_at DESC').all
      else
        session[:user_id] = nil
        flash[:notice] = "You have been logged out because it's been more than 24 hours since you last logged in"
      end
    end 
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
