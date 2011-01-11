require 'openid/store/filesystem'
require File.join(Rails.root,'config/omniauth_settings')
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :open_id, OpenID::Store::Filesystem.new(Rails.root+'/tmp/openid.store')
  provider :twitter, OMNIAUTH_TWITTER_KEY, OMNIAUTH_TWITTER_SECRET
  provider :facebook, OMNIAUTH_FACEBOOK_KEY, OMNIAUTH_FACEBOOK_SECRET
  provider :linked_in, OMNIAUTH_LINKED_IN_KEY, OMNIAUTH_LINKED_IN_SECRET
  provider :thirty_seven_signals, OMNIAUTH_BASECAMP_ID, OMNIAUTH_BASECAMP_SECRET
  provider :github, OMNIAUTH_GITHUB_ID, OMNIAUTH_GITHUB_SECRET
  #provider :LDAP, "LDAP-Login #{LDAP_HOST}", { :host => LDAP_HOST, :port => LDAP_PORT, :method => :plain, 
  #         :base => LDAP_TREEBASE, :uid => 'uid', :bind_dn => "uid=%s,cn=users,dc=xs1,dc=intern,dc=wwedu,dc=com" }

end

