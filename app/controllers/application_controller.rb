class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_filter :session, :except => [:deauthorize]
  before_filter :get_email
  
  def get_email
    if session[:user_id]
      @user = User.find(session[:user_id], :select => "email, name, uid, id")
    end
  end
  
  def destroy_job
    @job = Delayed_Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(users_path) }
      format.xml  { head :ok }
    end
  end   
  
end
