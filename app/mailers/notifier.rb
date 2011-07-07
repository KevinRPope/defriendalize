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
  
  def facebook_error(user) #This one is for when the user has changed their FB password or the FB Session has expired.
    @user = user
    mail(:to => user.email, :subject => "Your Defriendalize Account Is On Standby")
  end
  
  def cron_test()
    @num_workers = @@heroku.info('empty-journey-469')[:workers].to_i
    mail(:to => "pope.kevin@gmail.com", :subject => "cron job has run")
    MethodCallLog.log(User.find(1), "cron_test")
  end
  
  def deauth_test(cipher_token)
    @cipher_token = cipher_token
    mail(:to => "pope.kevin@gmail.com", :subject => "user has deauthorized your application")
  end
end
