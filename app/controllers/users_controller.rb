class UsersController < ApplicationController
  before_filter :authorize, {:except => [:destroy, :new, :create, :update, :edit, :show, :delete_account, :unsubscribe, :resubscribe]}
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    @num_workers = @@heroku.info('empty-journey-469')[:workers].to_i
    @jobs = Delayed_Job.all
    @job_count = Delayed_Job.all.count
  end
  
  def delete_account
    @user = User.find(session[:user_id])
    respond_to do |format|
      format.html # delete_account.html.erb
    end
  end
  
  def unsubscribe
    User.unsubscribe(params[:uid])
    flash[:notice] = 'You have been unsubscribed from all emails'
    if session[:user_id]
      redirect_to user_path :id => session[:user_id] 
    else
      redirect_to root_path
    end
  end
  
  def resubscribe
    User.resubscribe(session[:user_id])
    flash[:notice] = 'You have been resubscribed to all emails'
    redirect_to user_path
  end
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(session[:user_id])
    p @user
    @friend_count = Connection.where(:last_action => ['New Connection', 'Created Connection', 'create', 'Refriended']).find_all_by_user_id(session[:user_id]).count
    p close_instructions = Delayed_Job.where(["handler LIKE ?","%method_name: :worker_close%"]).all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(session[:user_id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(session[:user_id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(session[:user_id])
    Notifier.deleted_account(@user).deliver
    session[:user_id] = nil
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def authorize
    unless session[:user_id] == 1
      redirect_to root_path
      flash[:notice] = "You are not authorized to perform this function"
    end
  end
end
