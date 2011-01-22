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
  
  def self.transfer_userids
    connections = Connection.all
    connections.each do |c|
      c.user_id = User.find_by_uid(c.user_facebook_id).id
      c.save!
    end
    interests = Interest.all
    interests.each do |c|
      c.user_id = User.find_by_uid(c.user_facebook_id).id
      c.save!
    end
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.email = auth["extra"]["user_hash"]["email"]
      user.name = auth["extra"]["user_hash"]["name"]
      user.gender = auth["extra"]["user_hash"]["gender"]
      user.birthdate = auth["extra"]["user_hash"]["birthday"]
      user.access_token = auth["credentials"]["token"]
      user.relationship_status = auth["extra"]["user_hash"]["relationship_status"]
      user.location = auth["extra"]["user_hash"]["location"]["name"]
    end
  end
=begin
  def self.get_birthdate(user)
    Connection.
  end
=end

  def self.get_profile_pic(user)
    request = Net::HTTP.new("graph.facebook.com", 443)
    request.use_ssl = true
    data_wrapper = request.get("/#{user.uid}/picture")
    unless data_wrapper['location'].nil?
      user.profile_picture = data_wrapper['location']
      user.save
    end
  end

end
