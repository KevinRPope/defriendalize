require 'heroku'
require 'delayed_job'

class Autoscale
  class << self
    def testerama
      Education.create(:level => 'PhD', :name => 'School of Hard Knocks', :user_id => 1)
    end
#    DelayedJob.handle_asynchronously :testerama, :run_at => Proc.new {5.minutes.from_now}
  end
  
  private
  
  def extra_test
    p "Extra"
  end
#  handle_asynchronously :extra_test#, :run_at => Proc.new {30.seconds.from_now}
  #handle_asynchronously
=begin
  
  Order of operations:
  1) Check for number of dynos.  
    1a) If 0, set to 1 and return.  
    1b) If 1, remove the 'shut down the worker' thread from the delayed job table
  2) check wait time, if more than 10 seconds, spawn another worker (but comment this bit out for now)
  3) check the queue length, and if it is 0, set the death time for the worker in the delayed job table.
  
=end

end
