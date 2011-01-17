class DelayedJob
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :class_name, :required => true
  field   :args

  def self.enqueue(class_name,*args)
    job = self.create( :class_name => class_name, :args => args )
  end
  
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
      sleep(  )
    end
  end

end