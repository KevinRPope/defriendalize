class Connection < ActiveRecord::Base
  belongs_to :user
#  helper_method :fql_friend_check
#  after_save {|record| p record.friend_name.to_s + " was saved successfully to the Connections table" }
  
  def self.create_connections(user)
    friend_data = talk_to_facebook(user, "friends")
    connections = Array.new
    friend_data["data"].each do |d|
      connections << Connection.new(
        :user_facebook_id => user.uid,
        :friend_facebook_id => d["id"],
        :friend_name => d["name"],
        :last_action => 'Created Connection',
        :user_id => user.id)
    end
    Connection.import connections, :validate => false
  end
  #handle_asynchronously :create_connections

  def self.check_connections(user, email_check = false)
    new_friend_data = talk_to_facebook(user, "friends")
    new_array = Array.new
    old_friend_data = Connection.where(:last_action => ['create', 'Created Connection', 'New Connection', 'Reactivated Account', 'Refriended']).find_all_by_user_facebook_id(user.uid, :select => "friend_facebook_id")
    old_array = Array.new
    old_friend_data.each do |o|
      old_array << o.friend_facebook_id
    end
    new_friend_data["data"].each do |c|
      new_array << c["id"]
    end
    
    new_friends = (new_array - old_array)
    #connections = Array.new
    refriend = 0
    reactivate = 0
    new_count = 0
    defriend_count = 0
    cancel = 0
    new_friends.each do |friend|
      update_connection = Connection.find_by_user_facebook_id_and_friend_facebook_id(user.uid, friend)
      if update_connection
        if update_connection.last_action == 'Defriended'
          update_connection.last_action = 'Refriended'
          update_connection.save
          refriend = refriend + 1
        elsif update_connection.last_action == 'Canceled Account or Changed Privacy Settings'
          update_connection.last_action = 'Reactivated Account'
          update_connection.save   
          reactivate = reactivate + 1   
        end
      else
        c = Connection.new(
          :user_facebook_id => user.uid,
          :friend_facebook_id => friend,
          :friend_name => new_friend_data["data"].select{|hash| hash["id"] == friend.to_s}[0]["name"],
          :last_action => 'New Connection',
          :user_id => user.id)
        c.save
        new_count = new_count+1
      end
    end

    defriend = (old_array - new_array)
    defriend.each do |friend|
      friend_in_db = Connection.find_by_user_facebook_id_and_friend_facebook_id(user.uid, friend)
      if account_exists(friend)
        friend_in_db.last_action = 'Defriended'
        defriend_count = defriend_count + 1
      else
        friend_in_db.last_action = 'Canceled Account or Changed Privacy Settings'
        cancel = cancel + 1
      end
      friend_in_db.save
    end
    total = new_count + cancel + refriend + reactivate + defriend_count
    p "total: " + total.to_s
    if email_check && User.find(user.id).email_me && (total > 0)
      Notifier.friend_update(user, new_count, cancel, refriend, reactivate, defriend_count).deliver
      user.updated_at = Time.now
      p user.save
    end
      
  end
  #handle_asynchronously :check_connections
  
  def self.correct_reactived
    reactived = Connection.where(:last_action => 'Reactived Account')
    reactived.each do |r|
      r.last_action = 'Reactivated Account'
      p r.friend_name
      r.save
    end
  end
  
private

  def self.talk_to_facebook(user, info)
    friend_request = Net::HTTP.new("graph.facebook.com", 443)
    friend_request.use_ssl = true
    friend_data_wrapper = friend_request.get("/#{user.uid}/#{info}?access_token=#{user.access_token}")
    friend_data = ActiveSupport::JSON.decode(friend_data_wrapper.body)
  end  
  
  def self.account_exists(uid)
    friend_request = Net::HTTP.new("graph.facebook.com", 443)
    friend_request.use_ssl = true
    get_request = friend_request.get("/#{uid}")
    friend_data = ActiveSupport::JSON.decode(get_request.body)    
    if friend_data #friend_request.get("/#{uid}")
      return true
    else
      return false
    end
  end

end
