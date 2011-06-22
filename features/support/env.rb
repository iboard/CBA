# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] = "test"
require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
  add_filter "/features/"
end

require 'rubygems'
require 'spork'

Spork.prefork do
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

  require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
  require 'cucumber/rails/rspec'
  require 'cucumber/rails/world'
  require 'cucumber/web/tableish'

  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'

  Dir.new("#{Rails.root}/test/factories/").reject {|r| !r.match(/\.rb$/) }.each do |factory|
    require "#{Rails.root}/test/factories/#{factory}"
  end

  require 'factory_girl'
  require 'factory_girl/step_definitions'

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css

end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','..',
    'spec','factories','*.rb'))].each { |f| require f }
end



