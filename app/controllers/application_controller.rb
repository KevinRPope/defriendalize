class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_email
  before_filter :ensure_domain

  APP_DOMAIN = 'www.defriendalize.com'

  def ensure_domain
    if request.env['HTTP_HOST'] != APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end
  
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
