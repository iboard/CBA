# -*- encoding : utf-8 -*-
# Configuration YAML reader
module Secrets

  def self.secret
    @secrets ||= YAML::load( File::open(File::expand_path("../../#{keys_file}", __FILE__)))
  end

  def self.defined_providers
    secret['omniauth'].each { |provider, pair|}.map { |provider| provider[0].to_sym }
  end

private
  def self.keys_file 
    Rails.env == 'test' ? 'test_secrets.yml' : 'secrets.yml'
  end
end

