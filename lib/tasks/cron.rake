desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  
  #if Time.now.hour == 0 # run at midnight
    #user_list = User.where(:updated_at => 6.months.ago.to_date..6.days.ago.to_date).all #find(:all, :include => :connections, :conditions => ["connections.updated_at BETWEEN ? AND ?", 7.days.ago.to_date, Time.now.to_date])
    p Time.now.to_s
    if ENV["RAILS_ENV"] == "production"
      p user_list = User.find_by_sql(["select * from users where id not in (select user_id from method_call_logs where (action = ? AND created_at between ? and ?))", 'check_connections', 6.days.ago.to_date, 1.day.from_now.to_date])
    else
      p user_list = User.find_by_sql(["select * from users where id not in (select user_id from method_call_logs where (action = ? AND created_at between ? and ?))", 'check_connections', 1.days.from_now.to_date, 1.day.from_now.to_date])      
    end
    user_list.each do |ul|
      p "name: " + ul.name.to_s
      Connection.check_connections(ul, true)
    end
  #end
  Notifier.cron_test.deliver
end