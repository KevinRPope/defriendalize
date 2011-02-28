class Notifier < ActionMailer::Base
  default :from => "Defriendalize <no-reply@defriendalize.com>"
  
  def welcome(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Defriendalize")
    MethodCallLog.log(user, "welcome")
  end
  
  def friend_update(user, new_friend, canceled, refriend, reactivated, defriend) 
    @user = user
    @new_friend = new_friend
    @canceled = canceled
    @refriend = refriend
    @reactivated = reactivated
    @defriend = defriend
    mail(:to => user.email, :subject => "Your Weekly Defriendalize Update")
    MethodCallLog.log(user, "friend_update", "new: " + new_friend.to_s + "\ncancel: " +  canceled.to_s + "\nrefriend: " + refriend.to_s + "\nreactivated: " + reactivated.to_s + "\ndefriend: " + defriend.to_s)
  end
  
  def deleted_account(user)
    @user = user
    mail(:to => user.email, :subject => "Your Defriendalize Account Has Been Deleted")
    MethodCallLog.log(user, "deleted_account")
  end
  
  def email_unsubscribe(user)
    @user = user
  end
  
  def cron_test()
    mail(:to => "pope.kevin@gmail.com", :subject => "cron job has run")
    MethodCallLog.log(user, "cron_test")
  end
end
