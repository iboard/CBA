namespace :delayed_jobs do

  desc "Run background jobs"
  task :work => :environment do
    DelayedJob::run
  end

  desc "Requeue failed jobs"
  task :requeue => :environment do
    DelayedJob.all.each do |job|
      job.failed_with=nil
      job.save
    end
  end
  
  desc "Delete failed jobs"
  task :delete_failed_jobs => :environment do
    DelayedJob::delete_failed_jobs!
  end
end