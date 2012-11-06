require 'heroku'
require 'delayed_job'

class Autoscale
  #class << self
  APP_NAME = 'empty-journey-469'
  @@workers
    def self.new_user_autoscale(user, auth)
      Connection.create_connections(user)
      User.get_profile_pic(user)
      Notifier.welcome(user)
    end
    
    def self.update_user_autoscale(user, auth)
      Connection.check_connections(user)
      User.get_profile_pic(user)
    end
    
    def self.check_workers
      p "check_workers"
      if ENV["RAILS_ENV"] == "production"
        @workers = @@heroku.info(APP_NAME)[:workers].to_i
        p "production " + @workers.to_s + " workers"
        if @workers == 0
          Autoscale.add_workers(1)
          p "adding workers"
        else
          Autoscale.reset_worker_close
          p "delete workers: " + Time.now.to_s
          #logic to check if the queue is too long and more workers are needed
        end  
      else
        if @@workers.nil?
          @@workers = 0
          p "workers was nil"
        else
          p "workers was not nil: " + @@workers.to_s + " " + Time.now.to_s
        end
        if @@workers == 0
          Autoscale.add_workers(1)
          p "adding workers: " + @@workers.to_s + " " + Time.now.to_s
        else
          Autoscale.reset_worker_close
          p "delete workers: " + Time.now.to_s
          #logic to check if the queue is too long and more workers are needed
        end  
      end
    end
    
    def self.add_workers(number)
      if ENV["RAILS_ENV"] == "production"
        @@heroku.set_workers(APP_NAME, @workers + number)
      else
        @@workers = 1
      end
      Autoscale.set_worker_close
    end
    
    def self.reset_worker_close
      Autoscale.delete_worker_close
      Autoscale.set_worker_close
    end
    
    def self.set_worker_close
      Autoscale.delay(:run_at => 30.seconds.from_now).worker_close      
    end
    
    def self.worker_close
      #Do I need to stop worker processing?
      if ENV["RAILS_ENV"] == "production"
        p Delayed_Job.where(:run_at => Time.now.to_date..2.days.from_now.to_date, :last_error => nil).all.count.to_i
        if Delayed_Job.where(:run_at => Time.now.to_date..2.days.from_now.to_date, :last_error => nil).all.count.to_i > 0
          @@heroku.set_workers(APP_NAME, 0)
        else
          p Delayed_Job.where(:run_at => Time.now.to_date..2.days.from_now.to_date, :last_error => nil).all.inspect
          Autoscale.set_worker_close
        end
      else
        if Delayed_Job.where(:run_at => Time.now.to_date..2.days.from_now.to_date, :last_error => nil).all.count.to_i <= 1
          p @@workers = 0
        else
          p Autoscale.set_worker_close
        end
      end
    end
    
    def self.delete_worker_close
      close_instructions = Delayed_Job.where(["handler LIKE ?","%method_name: :worker_close%"]).all
      close_instructions.each do |e|
        p e.destroy 
      end
    end

end
