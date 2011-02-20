class User < ActiveRecord::Base
  has_many :connections, :dependent => :destroy
  has_many :interests, :dependent => :destroy
  has_many :educations, :dependent => :destroy
  
  #  after_save {|record| p record.friend_name.to_s + " was saved successfully to the Connections table" }
  #before_destroy :remove_other_entries
  
  def remove_other_entries
      Connection.delete_all("user_facebook_id = #{self.uid}")
      Interest.delete_all("user_facebook_id = #{self.uid}")
  end
    
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.email = auth["extra"]["user_hash"]["email"]
      user.name = auth["extra"]["user_hash"]["name"]
      user.gender = auth["extra"]["user_hash"]["gender"] || "Not Supplied"
      user.birthdate = auth["extra"]["user_hash"]["birthday"] || "Not Supplied"
      user.access_token = auth["credentials"]["token"]
      user.relationship_status = auth["extra"]["user_hash"]["relationship_status"] || "Not Supplied"
      if auth["extra"]["user_hash"]["location"]
        user.location = auth["extra"]["user_hash"]["location"]["name"] || "Not Supplied"
      end
    end
  end
=begin
  def self.get_birthdate(user)
    Connection.
  end
=end
  
  def self.update_user_info(user, auth)
      user.email = auth["extra"]["user_hash"]["email"]
      user.name = auth["extra"]["user_hash"]["name"]
      user.gender = auth["extra"]["user_hash"]["gender"] || "Not Supplied"
      user.birthdate = auth["extra"]["user_hash"]["birthday"] || "Not Supplied"
      user.access_token = auth["credentials"]["token"]
      user.relationship_status = auth["extra"]["user_hash"]["relationship_status"] || "Not Supplied"
      if auth["extra"]["user_hash"]["location"]
        user.location = auth["extra"]["user_hash"]["location"]["name"] || "Not Supplied"
      end
    user.save
  end
  
  def self.get_profile_pic(user)
    request = Net::HTTP.new("graph.facebook.com", 443)
    request.use_ssl = true
    data_wrapper = request.get("/#{user.uid}/picture")
    unless data_wrapper['location'].nil?
      user.profile_picture = data_wrapper['location']
      user.save
    end
  end

  def self.unsubscribe(uid)
    @user = User.find_by_uid(uid)
    @user.email_me = false
    @user.save
  end
  
  def self.resubscribe(id)
    @user = User.find(id)
    @user.email_me = true
    @user.save
  end

end
