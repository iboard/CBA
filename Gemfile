source 'http://rubygems.org'

gem 'simplecov', '>= 0.4.0', :require => false, :group => :test

gem "rails", "3.1.0.rc5"
# Rails 3.1 - Asset Pipeline

group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-script'
  gem 'uglifier'  
  gem 'json'
  gem 'jquery-rails'  
  gem 'therubyracer'
  gem 'execjs'
  gem 'sprockets', '~> 2.0.0.beta.12'
end


# Bundle gems needed for Mongoid
gem "mongoid", "~>2.0.1"   #, "2.0.0.rc.7"
gem "bson_ext"  #, "1.1.5"

# Bundle gem needed for Devise and cancan
gem "devise", "~>1.4.0" # ,"1.1.7"
gem "cancan"
gem "omniauth", "0.2.6"

# Bundle gem needed for paperclip and attachments
gem "mongoid-paperclip", :require => "mongoid_paperclip"

# MongoID Extensions and extras
gem 'mongoid-tree', :require => 'mongoid/tree'

# Bundle gems for views
gem "haml"
gem "will_paginate"
gem 'escape_utils'
gem "RedCloth", "4.2.4.pre3" # "4.2.5" doesn't work with ruby 1.9.3.preview1

# Markdown
# do "easy_install pygments" on your system
gem 'redcarpet'
gem 'albino'
gem "nokogiri", "1.4.6"

# Bundle gems for development 
group :development do
  gem "nifty-generators"
  gem "rails-erd"
  gem 'rdoc'
  gem 'unicorn'
  gem 'yard' #broken in OS X 10.7 see how to workarround this issue 
end

# Bundle gems for testing
group :test do
  gem 'json_pure'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec', '2.6.0'
  gem 'rspec-rails', '2.6.1'
  gem 'spork', '0.9.0.rc9'
  gem 'spork-testunit'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'ZenTest'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'ruby-growl'
  gem 'autotest-growl'
  gem "mocha"
  gem "gherkin"
end

