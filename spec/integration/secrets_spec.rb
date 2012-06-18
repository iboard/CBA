require 'spec_helper'

describe Secrets do
  it "Reads configuration yaml from secret.yml" do
    Secrets::secret['omniauth'].each do |service, definition|
      assert definition['key'] == service.to_s.upcase + "_KEY"
      assert definition['secret'] == service.to_s.upcase + "_SECRET"
    end
  end

  it "List defined providers" do
    assert Secrets::defined_providers == [
      :twitter, :facebook, :linkedin, 
      "37signals".to_sym, :github, :google_oauth2, :foursquare, :tumblr
    ], Secrets::defined_providers.inspect
  end

  it "provides openid storage" do
    assert Secrets::secret['openid']['store'] == "tmp/"
  end

  it "MUST be .gitignored!" do
    gitignore = File.read( File::expand_path('.gitignore', Rails.root))
    [
      /^config\/config.yml/,
      /^config\/database.yml/,
      /^config\/secrets.yml/,
      /^config\/mongoid.yml/,
      /^config\/settings\/production.yml/,
    ].each do |entry|
      gitignore.should match entry
    end
  end
end

