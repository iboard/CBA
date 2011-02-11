class Application < Thor

  include Thor::Actions
  Thor::Sandbox::Application.source_root(File.dirname(__FILE__)+"/../..")
  
  #no_tasks do
  #end


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
    
    # Prompt
    puts " Enter WITHOUT file-extensions! mylayout, not mylayout.css"
    puts " ---------------------------------------------------------"
    appname  = ask("Please enter the database name to use   :").strip
    css      = ask("CSS-file     default 'application'      :").strip
    layout   = ask("layout-file  default 'application'      :").strip
    css      = 'application' if css.strip.eql? ""
    layout   = 'application' if layout.strip.eql? ""
    appname  = 'cba'         if appname.strip.eql? ""
    
    # copy sample-files
    sample_files = %w( application.yml mailserver_setting.rb mongoid.yml omniauth_settings.rb )
    for target in sample_files
      copy_file( "config/#{target}.sample", "config/#{target}" )
    end
    
    `bundle install`
    
    # Patch files
    gsub_file  'config/mongoid.yml', 'APPNAME', appname
    gsub_file  'config/application.yml', /layout:([ |\t]*)(\S*)$/, "layout: #{layout}"
    gsub_file  'config/application.yml', /stylesheet_screen:([ |\t]*)(\S*)$/, "stylesheet_screen: #{css}"
    gsub_file  'config/application.yml', /stylesheet_print:([ |\t]*)(\S*)$/, "stylesheet_print:  #{css}"
    
    # copy files
    unless css.eql? 'application'
      puts "  Copy application.css to #{css}.css - edit to fit your needs"
      copy_file("public/stylesheets/application.css", "public/stylesheets/#{css}.css")
    end
    unless layout.eql? 'application'
      puts "  Copy application.html.erb to #{layout}.html.erb - edit to fit your needs"
      copy_file("app/views/layouts/application.html.erb", "app/views/layouts/#{layout}.html.erb")
    end
    
    # inject .gitignore
    unless css.eql? 'application'
      puts "  Adding #{css}.css to .gitignore"
      append_file( '.gitignore' ) do 
        "\npublic/stylesheets/#{css}.css"
      end 
    end
    unless layout.eql? 'application'
      puts "  Adding #{layout}.html.erb to .gitignore"
      append_file( '.gitignore' ) do 
        "\napp/views/layouts/#{layout}.html.erb"
      end       
    end
    
    
    puts ""
    puts "INSTALLATION COMPLETE!"
    puts ""
    puts "Please edit the files #{sample_files.join(', ')} to fit your needs"
    puts
    puts "First steps:"
    puts "  * cd to your app-directory"
    puts "  * Edit the files mentioned above - MAKE SURE SMTP WORKS!"
    puts "  * Start the server: 'rails server'"
    puts "  * Sign up your first user (first user will be admin automatically - ignore registration mail!)"
    puts ""
    puts "Thank you for installing CBA!"
    puts "If you need further help, please visit https://github.com/iboard/CBA/wiki"
    puts ""
    puts "Greetings"
    puts "  - Andi Altendorfer, @Nickendell"
    puts ""
  end
    
end
