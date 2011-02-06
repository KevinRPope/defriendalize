class UsersController < ApplicationController
  before_filter :authorize, {:except => [:destroy, :new, :create, :update, :edit, :show, :delete_account]}
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    @num_workers = @@heroku.info(APP_NAME)[:workers].to_i
    @jobs = Delayed_Job.all
  end
  
  def delete_account
    @user = User.find(session[:user_id])
    respond_to do |format|
      format.html # delete_account.html.erb
    end
  end
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(session[:user_id])
    @friend_count = Connection.where(:last_action => [:new, :create]).find_all_by_user_id(session[:user_id]).count
    
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
