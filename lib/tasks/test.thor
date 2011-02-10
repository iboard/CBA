class Application < Thor

  no_tasks do
    def gsub_file(filename,search,replace)
      f_in=File.read(filename)
      f_out=File.new(filename,"w")
      f_out << f_in.gsub(/#{search}/, replace)
      f_out.close
    end
  end


  desc "test_all", "Run tests and cucumber"
  def test_all
    puts "RUNNING TEST UNITS"
    system "rake test:units | grep tests.*assertions.*failures"
    puts "\nRUNNING TEST FUNCTIONALS"
    system "rake test:functionals | grep tests.*assertions.*failures"
    puts "\nRUNNING CUCUMBER"
    system "bundle exec cucumber | grep '[scenarios|steps]'"
  end
  
  desc "review", "Find REVIEW-Remarks"
  def review
    puts "\nSearching for REVIEW-Remarks in all files"
    system "find . -type f -exec grep -H \" REVIEW\" {} \\; | grep -v \..git | grep -v log\/"
  end

  desc "todo", "Find TODO-Remarks"
  def todo
    puts "\nSearching for TODO-Remarks in all files"
    system "find . -type f -exec grep -H \"TODO\" {} \\; | grep -v \..git | grep -v log\/"
  end

  desc "style", "Find STYLE-Remarks"
  def style
    puts "\nSearching for STYLE-Remarks in all files"
    system "find . -type f -exec grep -H \"STYLE\" {} \\; | grep -v \..git | grep -v log\/"
  end
  
  desc "configure", "Configure application"
  def configure  
    sample_files = %w( application.yml mailserver_setting.rb mongoid.yml omniauth_settings.rb )
    for target in sample_files
      unless File::exist? "config/#{target}"
        `cp config/#{target}.sample config/#{target}`
      else
        puts "config/#{target} exists. No action"
      end
    end
    `bundle install`
    appname  = ask("Please enter the database name to use   :").strip
    username = ask("Please enter the username for your admin:").strip
    useremail= ask("Please enter admins email-address       :").strip
    gsub_file 'db/seeds.rb', /INITIALUSERNAME/, username
    gsub_file 'db/seeds.rb', /INITIALEMAIL/, useremail  
    gsub_file 'config/mongoid.yml', 'APPNAME', appname
    puts ""
    puts "INSTALLATION COMPLETE!"
    puts ""
    puts "Please edit the files #{sample_files.join(', ')} to fit your needs"
    puts
    puts "First steps:"
    puts "  * cd to your app-directory"
    puts "  * Edit the files mentioned above"
    puts "  * run: 'rake db:setup'"
    puts "  * Start the server: 'rails server'"
    puts "  * Login with '#{useremail} and password 'cbaadmin'"
    puts "  * Change the password of your user"
    puts ""
    puts "Thank you for installing CBA!"
    puts "If you need further help, please visit https://github.com/iboard/CBA/wiki"
    puts ""
    puts "Greetings"
    puts "  - Andi Altendorfer, @Nickendell"
    puts ""
  end
    
end
