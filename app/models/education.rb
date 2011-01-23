class Education < ActiveRecord::Base
  belongs_to :user

  def self.create_education(user, auth)
    unless auth["extra"]["user_hash"]["education"].nil?
      auth["extra"]["user_hash"]["education"].each do |s|
        create! do |edu|
          edu.user_id = user.id
          edu.level = s["type"]
          edu.name = s["school"]["name"]
        end
      end
    end
  end

end
