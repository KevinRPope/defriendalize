require 'heroku'

class DefriendController < ApplicationController
  def index
    if session[:user_id]
      if (session[:expire] > Time.now)
        user = User.find(session[:user_id], :include = :connections)
        user.
        @connections = Connection.where(:user_id => session[:user_id], :last_action => ['Canceled Account or Changed Privacy Settings', 'Reactivated Account', 'Defriended', 'Refriended', 'New Connection'], :updated_at => 30.days.ago.to_date..1.day.from_now.to_date).order('updated_at DESC').all
      end
    end 
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
