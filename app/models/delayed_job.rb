# -*- encoding : utf-8 -*-

#
# Handle delayed jobs
#
# TODO: Add fields and functions for :do_not_run_before/_after
# and Priority
#
class DelayedJob
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  field   :class_name, :required => true
  field   :not_before, :type => Time

  class << self
    # ready jobs - where not_before is before now and not failed
    def ready
      where(:not_before.lt => Time.now.utc, :failed_with => nil)
    end

    # waiting
    def waiting
      where(:not_before.gte => Time.now.utc)
    end

    # failed
    def failed
      where(:failed_with.ne => nil)
    end
  end


  field   :args
  field   :failed_with

  # Store a request in the delayed_jobs-collection
  def self.enqueue(class_name,not_before,*args)
    job = self.create( :class_name => class_name,
                       :not_before => not_before,
                       :args => args
                     )
  end

  # Fetch the oldest job in the queue and run the <code>perform</code>-method
  # of the queued object. When done remove the job from the queue.
  def self.run_next_job
    job = self.ready.first
    if job
      puts "RUNNING #{job.inspect}" unless Rails.env.eql?('production')
      worker = eval("::#{job.class_name}.new(#{job.args})")
      if worker.respond_to? "perform"
        begin
          worker.perform
        rescue => e
          job.failed_with = e.to_s
          puts "-- JOB FAILED - MARKED AS FAILED WITH #{e.to_s}"
          job.save
          return
        end
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
      if self.ready.count > 0
        # There are jobs to execute
        begin
          self.run_next_job
        rescue => e
          puts "-- ERROR #{e} WHILE EXECUTING JOB #{self.first.inspect}"
        end
      else
        # No jobs ready yet.
        unless Rails.env == 'production'
          print "#{Time.now().to_s} - No jobs ready to execute. "
          print "#{self.waiting.count} waiting jobs. "
        end
        if self.failed.count > 0
          puts "#{self.failed.count} jobs marked failed"
        else
          puts "" unless Rails.env == 'production'
        end
      end
      puts "Sleeping #{CONSTANTS['sleep_in_delayed_jobs_worker']}" unless Rails.env == 'production'
      sleep( (CONSTANTS['sleep_in_delayed_jobs_worker'] || "60" ).to_i )
    end
  end


  # Delete failed jobs
  def self.delete_failed_jobs!
    puts "DELETING #{failed.count} JOB(S) FROM QUEUE"
    failed.delete_all
  end

end
