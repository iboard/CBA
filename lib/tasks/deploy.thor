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
                " 'cd #{deploy_config['production_path']}; git pull; touch tmp/restart.txt'")
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
  
end