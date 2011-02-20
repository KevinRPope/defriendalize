class Interest < ActiveRecord::Base
has_one :user

  def self.create_interests(user)
    likes_data = Connection.talk_to_facebook(user, "likes")
    interests = Array.new
    likes_data["data"].each do |d|
      interests << Interest.new(
        :user_facebook_id => user.uid,
        :category => d["category"],
        :name => d["name"],
        :category_facebook_id => d["id"],
        :current => true,
        :user_id => user.id)
    end
    Interest.import interests, :validate => false
  end

  def self.check_interests(user)
    new_likes_data = Connection.talk_to_facebook(user, "likes")
    new_array = Array.new
    #Eventually should probably set this such that interests that have been removed and then re-added aren't re-added to the db
    old_likes_data = Interest.where(:current => true).find_all_by_user_facebook_id(user.uid, :select => "category_facebook_id")
    old_array = Array.new
    old_likes_data.each do |o|
      old_array << o.category_facebook_id
    end
    new_likes_data["data"].each do |c|
      new_array << c["id"]
    end

    new_likes = (new_array - old_array)
    interests = Array.new
    new_likes.each do |like|
      i = Interest.new(
        :user_facebook_id => user.uid,
        :category_facebook_id => like,
        :name => new_likes_data["data"].select{|hash| hash["id"] == like.to_s}[0]["name"],
        :category => new_likes_data["data"].select{|hash| hash["id"] == like.to_s}[0]["category"],
        :current => true,
        :user_id => user.id)
      i.save
    end
    
    dislike = (old_array - new_array)
    dislike.each do |like|
      interest_in_db = Interest.find_by_user_facebook_id_and_category_facebook_id(user.uid, like)
      interest_in_db.current = false
      interest_in_db.save
    end
    
  end

end
