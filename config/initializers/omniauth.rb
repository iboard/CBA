# -*- encoding : utf-8 -*-
require 'openid/store/filesystem'

GOOGLE_PLACE_API_KEY      = 'YOUR_API_KEY_HERE'

Rails.application.config.middleware.use OmniAuth::Builder do

  # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  configure do |config|
    config.path_prefix = '/auth' if Rails.env == 'production'
  end


  Secrets::secret['omniauth'].each do |service, definition|
    provider service.to_sym, definition['key'], definition['secret']
  end

  if Secrets::secret['openid']
    _store = File::join(Rails.root, Secrets::secret['openid']['store'])
    provider :openid, :store => OpenID::Store::Filesystem.new(_store)
  end

  provider :identity, :fields => [:name], :auth_key => 'name', on_failed_registration: lambda { |env|    
    IdentitiesController.action(:new).call(env)
  }

end


module OmniAuth
  module Strategies
    autoload :Campus, File::join(Rails.root,'lib/campus_authorization')
  end
end

