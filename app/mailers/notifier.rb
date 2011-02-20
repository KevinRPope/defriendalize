class Notifier < ActionMailer::Base
  default :from => "no-reply@defriendalize.com"
  
  def welcome(user)
    @user = user
    p mail(:to => user.email, :subject => "Welcome to Defriendalize")
  end
  
  def friend_update(user, new_friend, canceled, refriend, reactivated, defriend) 
    @user = user
    @new_friend = new_friend
    @canceled = canceled
    @refriend = refriend
    @reactivated = reactivated
    @defriend = defriend
    mail(:to => user.email, :subject => "Your Weekly Defriendalize Update")
  end
  
  def deleted_account(user)
    @user = user
    mail(:to => user.email, :subject => "Your Defriendalize Account Has Been Deleted")
  end
  
  def email_unsubscribe(user)
    @user = user
  end
end
