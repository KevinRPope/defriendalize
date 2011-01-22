class SearchController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @search_results = Connection.talk_to_facebook(@user, "home")
  end

end
