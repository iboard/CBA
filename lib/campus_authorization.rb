# -*- encoding : utf-8 -*-
require 'omniauth'

#
#  OmniAuth extension for WWEDU campus authentication.
#
module OmniAuth
  module Strategies
    class Campus
      include OmniAuth::Strategy

      args [:consumer_key, :consumer_secret]
      option :name, 'campus'
      option :consumer_options, {}
      option :open_timeout, 30
      option :read_timeout, 30
      option :authorize_params, {}

      option :fields, ["uid", "username", "email"]

      uid { raw_info[:uid] }

      option :client_options, {
        :authorize_url => 'http://campus.wwedu.com/omniauth'
      }

      info do
        {
          :name => raw_info[:username],
          :email => raw_info[:email],
          :uid => raw_info[:uid]
        }
      end
    
      extra do
        {'raw_info' => raw_info}
      end
    
      def raw_info
        {
          uid: request.params["uid"], 
          username: request.params["username"], 
          email: request.params["email"], 
          token: request.params["token"]
        }
      end

      def request_phase
        r = Rack::Response.new
        r.redirect "http://campus.wwedu.com/omniauth"
        r.finish
      end

      def callback_phase
        sha1 = Digest::SHA1.hexdigest("a mix of #{raw_info[:uid]} #{options[:consumer_secret]}, #{options[:consumer_key]}, #{raw_info[:username]}, #{raw_info[:email]}")

        # check if the request comes from Campus or not
        if sha1 == raw_info[:token]
          super
        else
        # OmniAuth takes care of the rest
          fail!(:invalid_credentials)
        end
      end

    end
  end
end
