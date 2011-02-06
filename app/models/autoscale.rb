require 'heroku'
require 'delayed_job'

class Autoscale
  #class << self
  APP_NAME = 'empty-journey-469'
    def self.new_user_autoscale(user, auth)
      Autoscale.check_workers
      
      Connection.delay.create_connections(user)
      Education.delay.create_education(user, auth)
      Interest.delay.create_interests(user)
      User.delay.get_profile_pic(user)
      
      Autoscale.check_worker_close
    end
    
    def self.update_user_autoscale(user, auth)
                                                                            p "workers before check_workers method: " + @workers.to_s
      Autoscale.check_workers
                                                                            p "workers after check_workers method: " + @workers.to_s
      Connection.delay.check_connections(user)
      Interest.delay.check_interests(user)
      User.delay.update_user_info(user, auth)
      User.delay.get_profile_pic(user)
                                                                            p "workers before delayed_close method: " + @workers.to_s 
      Autoscale.check_worker_close
                                                                            p "workers after delayed_close method: " + @workers.to_s
    end
    

    
    def self.check_workers
      @workers = @@heroku.info(APP_NAME)[:workers].to_i
      
      if @workers == 0
        Autoscale.add_workers(1)
        #Do I need to enter a line here about starting the worker processing jobs?
      else
        Autoscale.delete_worker_close
        #logic to check if the queue is too long and more workers are needed
      end  
    end
    
    def self.add_workers(number)
      if ENV["RAILS_ENV"] == "production"
        @@heroku.set_workers(APP_NAME, @workers + number)
      else
        @workers = 1
      end
    end
    
    def self.check_worker_close
      if Delayed_Job.all.count < 6
        Autoscale.delay(:run_at => 30.seconds.from_now).worker_close
      end
    end
    
    def self.worker_close
      #Do I need to stop worker processing?
      if ENV["RAILS_ENV"] == "production"
        if Delayed_Job.all.count.to_i == 1
          p @@heroku.info(APP_NAME)[:workers].to_i
          @@heroku.set_workers(APP_NAME, 0)
          p @@heroku.info(APP_NAME)[:workers].to_i
        else
          p Delayed_Job.all.count.to_i
          Autoscale.delay(:run_at => 30.seconds.from_now).worker_close
        end
      else
        if Delayed_Job.all.count.to_i == 1
          p @workers = 0
        else
          p Autoscale.delay(:run_at => 30.seconds.from_now).worker_close
        end
      end
      p "workers during delayed_close method: " + @workers.to_s
    end
    
    def self.delete_worker_close
      close_instructions = Delayed_Job.all(:conditions => ["handler LIKE ?","%method_name: :delayed_worker_close%"])
      close_instructions.each do |e|
        e.destroy 
      end
    end
      
#    DelayedJob.handle_asynchronously :testerama, :run_at => Proc.new {5.minutes.from_now}

=begin
  
  Order of operations:
  1) Check for number of dynos.  
    1a) If 0, set to 1 and return.  
    1b) If 1, remove the 'shut down the worker' thread from the delayed job table
  2) check wait time, if more than 10 seconds, spawn another worker (but comment this bit out for now)
  3) check the queue length, and if it is 0, set the death time for the worker in the delayed job table.
  
  --- !ruby/struct:Delayed::PerformableMethod 
  object: !ruby/class Autoscale
  method_name: :delayed_worker_close
  args: []

  
  
=end

end
