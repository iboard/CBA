class Deploy < Thor

  desc "production [--force]", "git pull on the server and restart"
  method_options :force => :boolean  
  def production
    puts "THE APPLICATION IS GOING TO BE UPDATED ON THE SERVER"
    puts "===================================================="
    doit = options[:force] ? 'Yes' : ask("Are you sure you want to install on server? (Yes,No):")
    if doit.eql?('Yes')
      # Load the config from application.yml
      config_file =  File.expand_path('../../../config/application.yml', __FILE__)
      deploy_config=YAML.load_file(config_file)['deploy']
      puts "Here we go...."
      
      # Show what is going to happen
      puts "  Production server   :#{deploy_config['production_server']}"
      puts "  Production user     :#{deploy_config['production_user']}"
      puts "  Production path     :#{deploy_config['production_path']}"
      
      # Ask one more
      system "git status"
      sure = options[:force] ? 'Yes' : ask("Are you sure your repository is clean and code is tested? (Yes,No):")
      if sure.eql?('Yes')
        #
        # DOIT
        #
        puts "Push to origin/master ...."
        system( 'git push origin master')
        puts "Pull and restart on the server"
        system( "ssh #{deploy_config['production_user']}@#{deploy_config['production_server']} "+
                " '. ~/.profile; cd #{deploy_config['production_path']}; git pull; thor deploy:restart'")
        puts "DONE - Please check your application now!"
      else
        puts "Aborted. Before you deploy make sure that:"
        puts "   1. thor application:test_all is green"
        puts "   2. you did a commit"
      end
    else
      puts "Aborted. Nothing happend (Yes is case-sensitive here ;-)"
    end
  end
  
  
  desc "restart [--worker_only]", "kill 'rake jobs:work' and 'touch tmp/restart.txt'"
  method_options :worker_only => :boolean
  def restart
    kill_pid("ps x|grep delayed_jobs|grep -v grep")
    unless options[:worker_only]
      print "Touching tmp/restart.txt ... => "
      puts "OK" if system( "touch tmp/restart.txt" )
    end
  end
  
  desc "doc [--source] [--target] [--ssh]", "generate and deploy YARD documentation"
  method_options :source => :string, :target => :string, :ssh => :boolean
  def doc
    target = options[:target] ? options[:target] : "root@dav.iboard.cc:/var/www/dav/doc/cba/"
    source = options[:source] ? options[:source] : "doc/*"
    ssh    = options[:ssh] ? '-e ssh' : ''
    `rm -rf doc/*; yardoc --protected --title "CBA API Documantation" Gemfile app/**/*rb lib/**/*rb spec/*rb spec/support/*rb; rsync --delete -avz #{ssh} #{source} #{target}`
  end
  
  
  private
  def kill_pid(cmd)
    p=File::popen(cmd, "r")
    if p
      tasks = p.read.strip
      if tasks.empty?
        puts "No worker found"
      else
        pid = tasks.split(" ").first
        print "worker is running with PID #{pid} - going to kill it ... => "
        killcmd = "kill #{pid}"
        puts "OK" if system(killcmd)
      end
      p.close
    else
      puts "CAN'T EXECUTE #{cmd}!"
    end
  end  
end