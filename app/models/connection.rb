class Connection < ActiveRecord::Base
  belongs_to :user
  
#  after_save {|record| p record.friend_name.to_s + " was saved successfully to the Connections table" }
  
  def self.create_connections(user)
    friend_data = talk_to_facebook(user, "friends")
    connections = Array.new
    friend_data["data"].each do |d|
      connections << Connection.new(
        :user_facebook_id => user.uid,
        :friend_facebook_id => d["id"],
        :friend_name => d["name"],
        :last_action => "create")
    end
    Connection.import connections, :validate => false
  end
  #handle_asynchronously :create_connections

  def self.check_connections(user)
    new_friend_data = talk_to_facebook(user, "friends")
    new_array = Array.new
    old_friend_data = Connection.where(:last_action => ['create', 'new']).find_all_by_user_facebook_id(user.uid, :select => "friend_facebook_id")
    old_array = Array.new
    old_friend_data.each do |o|
      old_array << o.friend_facebook_id
    end
    new_friend_data["data"].each do |c|
      new_array << c["id"]
    end

    new_friends = (new_array - old_array)
    connections = Array.new
    new_friends.each do |friend|
      c = Connection.new(
        :user_facebook_id => user.uid,
        :friend_facebook_id => friend,
        :friend_name => new_friend_data["data"].select{|hash| hash["id"] == friend.to_s}[0]["name"],
        :last_action => "new")
      c.save
    end

    defriend = (old_array - new_array)
    defriend.each do |friend|
      friend_in_db = Connection.find_by_user_facebook_id_and_friend_facebook_id(user.uid, friend)
      if account_exists(friend)
        friend_in_db.last_action = "defriend"
      else
        friend_in_db.last_action = "cancelled"
      end
      friend_in_db.save
    end
  end
  #handle_asynchronously :check_connections

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
