class ConnectionsController < ApplicationController
  before_filter :authorize, {:include => [:index]}
  
  # GET /connections
  # GET /connections.xml
  def index
    
    if session[:user_id]
      #Interest.check_interests(User.find(session[:user_id]))
      @connections = Connection.all
      
    end
#    @connections = Connection.find_by_user_facebook_id(user.uid)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @connections }
    end
  end

  def update_connections
    Connection.update_connections(session[:user_id])
  end

  # GET /connections/1
  # GET /connections/1.xml
  def show
    @connection = Connection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @connection }
    end
  end

  # GET /connections/new
  # GET /connections/new.xml
  def new
    @connection = Connection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @connection }
    end
  end

  # GET /connections/1/edit
  def edit
    @connection = Connection.find(params[:id])
  end

  # POST /connections
  # POST /connections.xml
  def create
    @connection = Connection.new(params[:connection])

    respond_to do |format|
      if @connection.save
        format.html { redirect_to(@connection, :notice => 'Connection was successfully created.') }
        format.xml  { render :xml => @connection, :status => :created, :location => @connection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /connections/1
  # PUT /connections/1.xml
  def update
    @connection = Connection.find(params[:id])

    respond_to do |format|
      if @connection.update_attributes(params[:connection])
        format.html { redirect_to(@connection, :notice => 'Connection was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1
  # DELETE /connections/1.xml
  def destroy
    @connection = Connection.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.html { redirect_to(connections_url) }
      format.xml  { head :ok }
    end
  end
end
