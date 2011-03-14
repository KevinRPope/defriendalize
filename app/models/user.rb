class User < ActiveRecord::Base
  has_many :connections, :dependent => :destroy
  
  #  after_save {|record| p record.friend_name.to_s + " was saved successfully to the Connections table" }
  #before_destroy :remove_other_entries
  
  def remove_other_entries
      Connection.delete_all("user_facebook_id = #{self.uid}")
  end
    
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.email = auth["extra"]["user_hash"]["email"]
      user.name = auth["extra"]["user_hash"]["name"]
      user.gender = auth["extra"]["user_hash"]["gender"] || "Not Supplied"
      user.access_token = auth["credentials"]["token"]
      user.email_me = true
      if auth["extra"]["user_hash"]["location"]
        user.location = auth["extra"]["user_hash"]["location"]["name"] || "Not Supplied"
      end
    end
  end
  
  def self.update_user_info(user, auth)
    user.email = auth["extra"]["user_hash"]["email"]
    user.name = auth["extra"]["user_hash"]["name"]
    user.gender = auth["extra"]["user_hash"]["gender"] || "Not Supplied"
    user.access_token = auth["credentials"]["token"]
    if auth["extra"]["user_hash"]["location"]
      user.location = auth["extra"]["user_hash"]["location"]["name"] || "Not Supplied"
    end
    if user.email_me.nil?
      user.email_me = true
    end
    user.save
    MethodCallLog.log(user, "update_user_info")
  end
  
  def self.get_profile_pic(user)
    request = Net::HTTP.new("graph.facebook.com", 443)
    request.use_ssl = true
    data_wrapper = request.get("/#{user.uid}/picture")
    unless data_wrapper['location'].nil?
      user.profile_picture = data_wrapper['location']
      user.save
      MethodCallLog.log(user, "update_user_info")
    end
  end

  def self.unsubscribe(uid)
    user = User.find_by_uid(uid)
    user.email_me = false
    user.save
    MethodCallLog.log(user, "unsubscribe")
  end
  
  def self.resubscribe(id)
    user = User.find(id)
    user.email_me = true
    user.save
    MethodCallLog.log(user, "resubscribe")
  end

end
