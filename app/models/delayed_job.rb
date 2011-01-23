#
# Handle delayed jobs
#
# TODO: Add fields and functions for :do_not_run_before/_after
# and Priority
#
class DelayedJob
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :class_name, :required => true
  field   :args

  # Store a request in the delayed_jobs-collection
  def self.enqueue(class_name,*args)
    job = self.create( :class_name => class_name, :args => args )
  end
  
  # Fetch the oldest job in the queue and run the <code>perform</code>-method
  # of the queued object. When done remove the job from the queue.
  def self.run_next_job
    job = self.first
    if job
      worker = eval("::#{job.class_name}.new(#{job.args})")
      if worker.respond_to? "perform"
        worker.perform
      else
        puts "CLASS #{job.class_name} DOES NOT RESPOND TO 'perform'. JOB CANCELED"
      end
      job.delete
    end
  end
  
  # run the queue until the processed will be killed.
  # Sleep <code>CONSTANTS['sleep_in_delayed_jobs_worker']</code> seconds
  # between executing the next job. The delay-value can be configured in
  # the <code>application.yml</code> file.
  def self.run
    puts "RUNNING DELAYED JOBS LOOP - PRESS ^C OR SEND SIG_KILL TO TERMINATE"
    while true
      if self.count > 0
        puts "#{Time.now().to_s} - Starting next job"
        begin
          self.run_next_job
        rescue => e
          puts "-- ERROR #{e} WHILE EXECUTING JOB #{self.first.inspect}"
        end
      else
        puts "#{Time.now().to_s} - No pending jobs" unless Rails.env == 'production'
      end
      sleep( CONSTANTS['sleep_in_delayed_jobs_worker'].to_i || 60 )
    end
  end

end