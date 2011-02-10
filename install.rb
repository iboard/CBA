# Application Installation and Setup-script for CBA
# clone and setup CBA from http://github.com/iboard/CBA

# Usage: 
#
#   ruby < <(curl http://github.com/iboard/CBA/install.rb)
#
# More info: http://github.com/iboard/CBA/


=begin
 =========================================================================
                          HELPER FUNCTIONS
 ========================================================================= 
=end
SCREEN_WIDTH=79

class String
  def blank?
    self.strip == ""
  end
end

def ask(prompt)
  print prompt
  gets
end

unless defined? yes?
  def yes? prompt
    while true
      a=ask(prompt+" (Y/n)").strip.upcase
      return true if ['Y','YES'].include?(a)
      return false if ['N','NO'].include?(a)
      puts "Please answer Y, yes or N, no"
    end
  end
end
    

def terminate msg
  puts msg
  exit 1
end

def run_and_check(prompt,cmd,excepted,msg,suffix="\n")
  print "%-40.40s" % prompt
  print ": "
  begin
    p=File.popen(cmd,"r")
    rc=p.read.strip
    p.close
  rescue
    rc = ""
  end
  if rc =~ Regexp.new(excepted)
    print "OK" + suffix
    return rc.strip
  else
    print "FAILED" + "\n    " + msg +(rc=="" ? "" : "\n    ")+ rc + suffix
    return false
  end
end

def run_and_get(prompt,cmd,msg,suffix="\n")
  rc = run_and_check(prompt,cmd,".",msg,'')
  unless rc
    print suffix
    return false
  end
  print " => "+rc+suffix
  return rc.strip
end

=begin
 =========================================================================
                                MAIN
 ========================================================================= 
=end

puts "="*SCREEN_WIDTH
puts "CBA INSTALLATION"
puts "Any problems? See http://github.com/iboard/CBA/issues"
puts "="*SCREEN_WIDTH

#----------------------------------------------------------------------------
# Test Environment and fetch system parameters
#----------------------------------------------------------------------------

puts "1. Test environment"
puts "-------------------"

os=run_and_get("Checking for OS","uname","COULD NOT DETECT OPERATING SYSTEM")
unless os > ""
  puts "Application couldn't be install using this script."
  puts "Please install using:"
  puts "   git clone git://github.com/iboard/CBA.git [your_app_name]"
  puts "   and follow the instructions in README"
  exit 2
end

terminate "ABORTED" unless run_and_check(
  "Checking for git", "which git", "git", 
  "GIT NOT FOUND"
)

terminate "ABORTED" unless run_and_check(
  "Checking for ruby version 1.9.x", "ruby -v", "1.9.", 
  "RUBY 1.9.x SHOULD BE INSTALLED BUT CHECK RETURNS"
)

terminate "ABORTED" unless run_and_check(
  "Checking for rails version 3.x", "rails -v", "Rails 3\.", 
  "RAILS 3.x.x SHOULD BE INSTALLED BUT CHECK RETURNS"
)

mongo_version=run_and_get(
  "Checking for MongoDB", "mongo --version",
  "COULD NOT FIND MONGODB (Please install -> mongodb.org)"
)

mongod=run_and_get(
  "Checking if mongod is running", "ps xa|grep mongod|grep -v grep|sed 's/^.* \\///g'",
  "MongoDB daemon 'mongod' not found"
)

identify=run_and_get(
  "Checking for identify (ImageMagick)", "which identify",
  "COULD NOT FIND PROGRAM identify (Please install -> www.imagemagick.org)"
)

convert=run_and_get(
  "Checking for convert (ImageMagick)", "which convert",
  "COULD NOT FIND PROGRAM convert (Please install -> www.imagemagick.org)"
)

imagemagick_path=File::dirname(convert)

rails_root=run_and_get(
  "Checking for Rails.root","pwd","COULD NOT GET CURRENT WORKING DIRECTORY"
)
  
#----------------------------------------------------------------------------
# Summary
#----------------------------------------------------------------------------
puts "\nSummary " + "*"*(SCREEN_WIDTH-1-"Summary".length)
if !mongo_version || mongo_version.blank? 
  puts "  There is no local MongoDB found."
  puts "  You can use CBA, though you have to configure an external"
  puts "  MongoDB-Server."
elsif !mongod || mongod.blank?
  puts "  MongoDB seems to be installed but not started."
  puts "  Don't forget to start mongod before using the application or"
  puts "  configure an external MongoDB-Server."
else
  puts "  Everything looks fine."
end

puts "IF YOU CONTINUE, THE DIRECTORY #{rails_root} WILL BE REMOVED!"
puts "And then, CBA will be installed to #{rails_root}"
puts ""
app_name=File::basename(rails_root) 
cmd = "rm -r "+File::basename(rails_root)
`pwd`
unless yes?("Continiue with #{cmd}")
  puts "Canceled"
  exit 8
end
`cd ..; #{cmd}`
`git clone git://github.com/iboard/CBA.git #{app_name}`

###git :init
###git :add => '.'
###git :commit => "-m 'Initial commit of unmodified new Rails app'"
###
####----------------------------------------------------------------------------
#### Remove the usual cruft
####----------------------------------------------------------------------------
###puts "removing unneeded files..."
###run 'rm config/database.yml'
###run 'rm public/index.html'
###run 'rm public/favicon.ico'
###run 'rm public/images/rails.png'
###run 'rm README'
###run 'touch README'
###
###puts "banning spiders from your site by changing robots.txt..."
###gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
###gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
###
####----------------------------------------------------------------------------
#### Heroku Option
####----------------------------------------------------------------------------
###if heroku_flag
###  puts "adding Heroku gem to the Gemfile..."
###  gem 'heroku', '1.15.1', :group => :development
###end
###
####----------------------------------------------------------------------------
#### Haml Option
####----------------------------------------------------------------------------
###if haml_flag
###  puts "setting up Gemfile for Haml..."
###  append_file 'Gemfile', "\n# Bundle gems needed for Haml\n"
###  gem 'haml', '3.0.25'
###  gem 'haml-rails', '0.3.4', :group => :development
###  # the following gems are used to generate Devise views for Haml
###  gem 'hpricot', '0.8.3', :group => :development
###  gem 'ruby_parser', '2.0.5', :group => :development
###end
###
####----------------------------------------------------------------------------
#### jQuery Option
####----------------------------------------------------------------------------
###if jquery_flag
###  gem 'jquery-rails'  #, '0.2.6'
###end
###
####----------------------------------------------------------------------------
#### Set up Mongoid
####----------------------------------------------------------------------------
###puts "setting up Gemfile for Mongoid..."
###gsub_file 'Gemfile', /gem \'sqlite3-ruby/, '# gem \'sqlite3-ruby'
###append_file 'Gemfile', "\n# Bundle gems needed for Mongoid\n"
###gem "mongoid", "2.0.0.beta.20"
###gem 'bson_ext', '1.1.5'
###
###puts "installing Mongoid gems (takes a few minutes!)..."
###run 'bundle install'
###
###puts "creating 'config/mongoid.yml' Mongoid configuration file..."
###run 'rails generate mongoid:config'
###
###puts "modifying 'config/application.rb' file for Mongoid..."
###gsub_file 'config/application.rb', /require 'rails\/all'/ do
###<<-RUBY
#### If you are deploying to Heroku and MongoHQ,
#### you supply connection information here.
###require 'uri'
###if ENV['MONGOHQ_URL']
###  mongo_uri = URI.parse(ENV['MONGOHQ_URL'])
###  ENV['MONGOID_HOST'] = mongo_uri.host
###  ENV['MONGOID_PORT'] = mongo_uri.port.to_s
###  ENV['MONGOID_USERNAME'] = mongo_uri.user
###  ENV['MONGOID_PASSWORD'] = mongo_uri.password
###  ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub('/', '')
###end
###
###require 'mongoid/railtie'
###require 'action_controller/railtie'
###require 'action_mailer/railtie'
###require 'active_resource/railtie'
###require 'rails/test_unit/railtie'
###RUBY
###end
###
####----------------------------------------------------------------------------
#### Tweak config/application.rb for Mongoid
####----------------------------------------------------------------------------
###gsub_file 'config/application.rb', /# Configure the default encoding used in templates for Ruby 1.9./ do
###<<-RUBY
###config.generators do |g|
###      g.orm             :mongoid
###    end
###
###    # Configure the default encoding used in templates for Ruby 1.9.
###RUBY
###end
###
###puts "prevent logging of passwords"
###gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
###
####----------------------------------------------------------------------------
#### Set up jQuery
####----------------------------------------------------------------------------
###if jquery_flag
###  run 'rm public/javascripts/rails.js'
###  puts "replacing Prototype with jQuery"
###  # "--ui" enables optional jQuery UI
###  run 'rails generate jquery:install --ui'
###end
###
####----------------------------------------------------------------------------
#### Set up Devise
####----------------------------------------------------------------------------
###puts "setting up Gemfile for Devise..."
###append_file 'Gemfile', "\n# Bundle gem needed for Devise\n"
###gem 'devise', '1.1.5'
###
###puts "installing Devise gem (takes a few minutes!)..."
###run 'bundle install'
###
###puts "creating 'config/initializers/devise.rb' Devise configuration file..."
###run 'rails generate devise:install'
###run 'rails generate devise:views'
###
###puts "modifying environment configuration files for Devise..."
###gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '### ActionMailer Config'
###gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
###<<-RUBY
###config.action_mailer.default_url_options = { :host => 'localhost:3000' }
###  # A dummy setup for development - no deliveries, but logged
###  config.action_mailer.delivery_method = :smtp
###  config.action_mailer.perform_deliveries = false
###  config.action_mailer.raise_delivery_errors = true
###  config.action_mailer.default :charset => "utf-8"
###RUBY
###end
###gsub_file 'config/environments/production.rb', /config.i18n.fallbacks = true/ do
###<<-RUBY
###config.i18n.fallbacks = true
###
###  config.action_mailer.default_url_options = { :host => 'yourhost.com' }
###  ### ActionMailer Config
###  # Setup for production - deliveries, no errors raised
###  config.action_mailer.delivery_method = :smtp
###  config.action_mailer.perform_deliveries = true
###  config.action_mailer.raise_delivery_errors = false
###  config.action_mailer.default :charset => "utf-8"
###RUBY
###end
###
###puts "creating a User model and modifying routes for Devise..."
###run 'rails generate devise User'
###
###puts "adding a 'name' attribute to the User model"
###gsub_file 'app/models/user.rb', /end/ do
###<<-RUBY
###  field :name
###  validates_presence_of :name
###  validates_uniqueness_of :name, :email, :case_sensitive => false
###  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
###end
###RUBY
###end
###
####----------------------------------------------------------------------------
#### Modify Devise views
####----------------------------------------------------------------------------
###puts "modifying the default Devise user registration to add 'name'..."
###if haml_flag
###   inject_into_file "app/views/devise/registrations/edit.html.haml", :after => "= devise_error_messages!\n" do
###<<-RUBY
###  %p
###    = f.label :name
###    %br/
###    = f.text_field :name
###RUBY
###   end
###else
###   inject_into_file "app/views/devise/registrations/edit.html.erb", :after => "<%= devise_error_messages! %>\n" do
###<<-RUBY
###  <p><%= f.label :name %><br />
###  <%= f.text_field :name %></p>
###RUBY
###   end
###end
###
###if haml_flag
###   inject_into_file "app/views/devise/registrations/new.html.haml", :after => "= devise_error_messages!\n" do
###<<-RUBY
###  %p
###    = f.label :name
###    %br/
###    = f.text_field :name
###RUBY
###   end
###else
###   inject_into_file "app/views/devise/registrations/new.html.erb", :after => "<%= devise_error_messages! %>\n" do
###<<-RUBY
###  <p><%= f.label :name %><br />
###  <%= f.text_field :name %></p>
###RUBY
###   end
###end
###
####----------------------------------------------------------------------------
#### Create a home page
####----------------------------------------------------------------------------
###puts "create a home controller and view"
###generate(:controller, "home index")
###gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
###
###puts "set up a simple demonstration of Devise"
###gsub_file 'app/controllers/home_controller.rb', /def index/ do
###<<-RUBY
###def index
###    @users = User.all
###RUBY
###end
###
###if haml_flag
###  run 'rm app/views/home/index.html.haml'
###  # we have to use single-quote-style-heredoc to avoid interpolation
###  create_file 'app/views/home/index.html.haml' do 
###<<-'FILE'
###- @users.each do |user|
###  %p User: #{link_to user.name, user}
###FILE
###  end
###else
###  append_file 'app/views/home/index.html.erb' do <<-FILE
###<% @users.each do |user| %>
###  <p>User: <%=link_to user.name, user %></p>
###<% end %>
###  FILE
###  end
###end
###
####----------------------------------------------------------------------------
#### Create a users page
####----------------------------------------------------------------------------
###generate(:controller, "users show")
###gsub_file 'config/routes.rb', /get \"users\/show\"/, '#get \"users\/show\"'
###gsub_file 'config/routes.rb', /devise_for :users/ do
###<<-RUBY
###devise_for :users
###  resources :users, :only => :show
###RUBY
###end
###
###gsub_file 'app/controllers/users_controller.rb', /def show/ do
###<<-RUBY
###before_filter :authenticate_user!
###
###  def show
###    @user = User.find(params[:id])
###RUBY
###end
###
###if haml_flag
###  run 'rm app/views/users/show.html.haml'
###  # we have to use single-quote-style-heredoc to avoid interpolation
###  create_file 'app/views/users/show.html.haml' do <<-'FILE'
###%p
###  User: #{@user.name}
###  FILE
###  end
###else
###  append_file 'app/views/users/show.html.erb' do <<-FILE
###<p>User: <%= @user.name %></p>
###  FILE
###  end
###end
###
###if haml_flag
###  create_file "app/views/devise/menu/_login_items.html.haml" do <<-'FILE'
###- if user_signed_in?
###  %li
###    = link_to('Logout', destroy_user_session_path)
###- else
###  %li
###    = link_to('Login', new_user_session_path)
###  FILE
###  end
###else
###  create_file "app/views/devise/menu/_login_items.html.erb" do <<-FILE
###<% if user_signed_in? %>
###  <li>
###  <%= link_to('Logout', destroy_user_session_path) %>        
###  </li>
###<% else %>
###  <li>
###  <%= link_to('Login', new_user_session_path)  %>  
###  </li>
###<% end %>
###  FILE
###  end
###end
###
###if haml_flag
###  create_file "app/views/devise/menu/_registration_items.html.haml" do <<-'FILE'
###- if user_signed_in?
###  %li
###    = link_to('Edit account', edit_user_registration_path)
###- else
###  %li
###    = link_to('Sign up', new_user_registration_path)
###  FILE
###  end
###else
###  create_file "app/views/devise/menu/_registration_items.html.erb" do <<-FILE
###<% if user_signed_in? %>
###  <li>
###  <%= link_to('Edit account', edit_user_registration_path) %>
###  </li>
###<% else %>
###  <li>
###  <%= link_to('Sign up', new_user_registration_path)  %>
###  </li>
###<% end %>
###  FILE
###  end
###end
###
####----------------------------------------------------------------------------
#### Generate Application Layout
####----------------------------------------------------------------------------
###if haml_flag
###  run 'rm app/views/layouts/application.html.erb'
###  create_file 'app/views/layouts/application.html.haml' do <<-FILE
###!!!
###%html
###  %head
###    %title Testapp
###    = stylesheet_link_tag :all
###    = javascript_include_tag :defaults
###    = csrf_meta_tag
###  %body
###    %ul.hmenu
###      = render 'devise/menu/registration_items'
###      = render 'devise/menu/login_items'
###    %p{:style => "color: green"}= notice
###    %p{:style => "color: red"}= alert
###    = yield
###FILE
###  end
###else
###  inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
###  <<-RUBY
###<ul class="hmenu">
###  <%= render 'devise/menu/registration_items' %>
###  <%= render 'devise/menu/login_items' %>
###</ul>
###<p style="color: green"><%= notice %></p>
###<p style="color: red"><%= alert %></p>
###RUBY
###  end
###end
###
####----------------------------------------------------------------------------
#### Add Stylesheets
####----------------------------------------------------------------------------
###create_file 'public/stylesheets/application.css' do <<-FILE
###ul.hmenu {
###  list-style: none;	
###  margin: 0 0 2em;
###  padding: 0;
###}
###
###ul.hmenu li {
###  display: inline;  
###}
###FILE
###end
###
####----------------------------------------------------------------------------
#### Create a default user
####----------------------------------------------------------------------------
###puts "creating a default user"
###append_file 'db/seeds.rb' do <<-FILE
###puts 'EMPTY THE MONGODB DATABASE'
###Mongoid.master.collections.reject { |c| c.name == 'system.indexes'}.each(&:drop)
###puts 'SETTING UP DEFAULT USER LOGIN'
###user = User.create! :name => 'First User', :email => 'user@test.com', :password => 'please', :password_confirmation => 'please'
###puts 'New user created: ' << user.name
###FILE
###end
###run 'rake db:seed'
###
####----------------------------------------------------------------------------
#### Finish up
####----------------------------------------------------------------------------
###puts "checking everything into git..."
###git :add => '.'
###git :commit => "-am 'modified Rails app to use Mongoid and Devise'"
###
###puts "Done setting up your Rails app with Mongoid and Devise."
