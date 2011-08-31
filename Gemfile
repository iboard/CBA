source 'http://rubygems.org'

gem 'simplecov', '>= 0.4.0', :require => false, :group => :test

gem "rails", "~> 3.1.0" # prev was rc8

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
gem "mongoid", "2.1.6" #  :path => "/Users/aa/Development/R31/mongoid-1" #"2.1.6"
gem "bson_ext"  #, "1.1.5"

# Bundle gem needed for Devise and cancan
gem "devise", :path => "/Users/aa/Development/R31/devise" #'1.2.rc2' #, "~>1.4.0" # ,"1.1.7"
gem "cancan"
gem "omniauth", "0.2.6"

# Bundle gem needed for paperclip and attachments
gem "mongoid-paperclip", :require => "mongoid_paperclip"

# MongoID Extensions and extras
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'mongoid_fulltext'

# Bundle gems for views
gem "haml"
gem "will_paginate", "3.0.pre4"
gem 'escape_utils'
gem "RedCloth", "4.2.5" #"4.2.4.pre3 doesn't work with ruby 1.9.2-p180

# Gems by iboard.cc <andreas@altendorfer.at>
gem "jsort", "~> 0.0.1"
gem 'progress_upload_field', '~> 0.0.1'


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
  gem 'yard'
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
  gem 'factory_girl_rails', "1.1.0"
  gem 'ZenTest', '4.5.0'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'ruby-growl'
  gem 'autotest-growl'
  gem "mocha"
  gem "gherkin"
  gem 'syntax'
end

