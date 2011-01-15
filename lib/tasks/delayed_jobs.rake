namespace :delayed_jobs do
  desc "Run background jobs"
  task :work => :environment do
    DelayedJob::run
  end
end