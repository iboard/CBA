source 'http://rubygems.org'

gem 'simplecov', :require => false, :group => :test #, '>= 0.4.0'

gem "rails", '3.2.2' #, "3.1.2" #, "~> 3.1.0" # prev was rc8

# Rails 3.1 - Asset Pipeline
group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'coffee-script'
  gem 'uglifier', '>= 1.0.3'
  gem 'json'
  gem 'jquery-rails'
  gem 'therubyracer'
  gem 'execjs'
  gem 'sprockets', '~> 2.1.2'
end


# Bundle gem needed for Devise and cancan
gem "devise", :git => 'git://github.com/iboard/devise.git' #:path => "/Users/aa/Development/R31/devise" #'1.2.rc2' #, "~>1.4.0" # ,"1.1.7"
gem "cancan"
# gem "omniauth", "0.2.6"
# Authentication
gem "omniauth", ">= 1.0.2"
gem "omniauth-twitter"
gem "omniauth-facebook"
gem "omniauth-linkedin"
gem "omniauth-37signals"
gem "omniauth-github"
gem "omniauth-openid"
gem "omniauth-google-apps"
gem "omniauth-google-oauth2"
gem "omniauth-tumblr"
gem "omniauth-foursquare"
gem 'bcrypt-ruby', '~> 3.0.0'
gem "omniauth-identity"

# Bundle gems needed for Mongoid
gem "mongo"
gem "mongoid", "~> 2.4"  # >= 3.0 was changed and doesn't work (without code-changes)
gem "bson_ext" #, "1.3.1" #, "1.1.5"

# Bundle gem needed for paperclip and attachments
# gem "paperclip" dependency of mongoid-paperclip
# mongoid-paperclip doesn't work with newest paperclip version (3.0.4)
gem "paperclip", "2.7.0"
gem "mongoid-paperclip", :require => 'mongoid_paperclip'

# MongoID Extensions and extras
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'mongoid_fulltext'
gem 'mongoid_taggable'
gem 'mongoid_spacial' # For GeoIndex


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
gem 'redcarpet', '1.17.2'
gem 'albino'
# gem "nokogiri", "1.4.6"
gem "nokogiri", "1.5.0"


gem "mongoid-rspec", ">= 1.4.4", :group => :test

gem 'jasmine', :group => [:development, :test]
gem 'headless', '0.1.0', :group => [:development, :test]
gem 'rspec', '>= 2.10.0', :group => [:development, :test]
gem 'rspec-rails', '>= 2.10.1', :group => [:development, :test]
gem 'json_pure', :group => [:development, :test]
gem 'capybara', :group => :test
gem 'database_cleaner', :group => [:development, :test]
gem 'cucumber-rails', '>= 1.3.0', :require => false, :group => :test
gem 'cucumber', '>= 1.2.0', :group => [:development, :test]
gem 'spork', '0.9.0.rc9', :group => :test
gem 'spork-testunit', :group => :test
gem 'launchy', :group => [:development, :test]
gem 'factory_girl_rails', ">= 1.7.0", :group => :test
gem 'ZenTest', '4.5.0', :group => [:development, :test]
gem 'autotest', :group => [:development, :test]
gem 'autotest-rails', :group => [:development, :test]
gem 'ruby-growl', :group => [:development, :test]
gem 'autotest-growl', :group => [:development, :test]
gem "mocha", :group => [:development, :test]
gem "gherkin", :group => [:development, :test]
gem 'syntax', :group => [:development, :test]
gem "nifty-generators", :group => [:development, :test]
gem "rails-erd", :group => [:development, :test]
gem 'rdoc', :group => [:development, :test]
gem 'unicorn', :group => [:development, :test]
gem 'yard', :group => [:development, :test]
gem 'rails3-generators', :group => [:development, :test]
gem "haml-rails", :group => [:development, :test]
