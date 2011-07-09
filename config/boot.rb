# -*- encoding : utf-8 -*-

require 'rubygems'
require 'yaml'
YAML::ENGINE.yamler= 'syck'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
#  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
