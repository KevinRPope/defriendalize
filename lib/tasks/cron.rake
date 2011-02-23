desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  
  #if Time.now.hour == 0 # run at midnight
    user_list = User.where(:updated_at => 6.months.ago.to_date..6.days.ago.to_date).all #find(:all, :include => :connections, :conditions => ["connections.updated_at BETWEEN ? AND ?", 7.days.ago.to_date, Time.now.to_date])
    user_list.each do |ul|
      Connection.check_connections(ul, true)
    end
  #end
end