class MethodCallLog < ActiveRecord::Base
  has_many :user

  def self.log(user, action, notes=nil)
    create! do |log|
      log.user_id = user.id
      log.name = user.name
      log.action = action
      log.notes = notes
    end
  end
  
end
