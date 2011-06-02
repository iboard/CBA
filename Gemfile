source 'http://rubygems.org'
gem 'simplecov', '>= 0.4.0', :require => false, :group => :test

gem 'rails','3.0.7'
gem 'jquery-rails'  

# Bundle gems needed for Mongoid
gem "mongoid", "~>2.0.1"   #, "2.0.0.rc.7"
gem "bson_ext"  #, "1.1.5"

# Bundle gem needed for Devise and cancan
gem "devise", "1.1.7"
gem "cancan"
gem "omniauth"

# Bundle gem needed for paperclip and attachments
gem "mongoid-paperclip", :require => "mongoid_paperclip"

# Bundle gems for views
gem "haml"
gem "will_paginate"
gem "RedCloth", "4.2.5"
gem "rdiscount"

# Bundle gems for development 
group :development do
  gem "nifty-generators"
  gem "rails-erd"
  gem 'rdoc'
  #  gem 'yard' broken in OS X 10.7
end

# Bundle gems for testing
group :test do
  gem 'json_pure'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec', '>=2.0.0.beta.13'
  gem 'rspec-rails', '>=2.0.0.beta.5'
  gem 'spork', '0.9.0.rc5'
  gem 'spork-testunit'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'escape_utils'
  gem 'ZenTest'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'ruby-growl'
  gem 'autotest-growl'
  gem "mocha"
  gem "gherkin"
end
