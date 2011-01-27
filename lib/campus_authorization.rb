require 'omniauth/core'
module OmniAuth
  module Strategies
    class Campus
      include OmniAuth::Strategy

      # receive parameters from the strategy declaration and save them
      def initialize(app, auth_id, secret, auth_redirect, options = {})
        @secret = secret
        @auth_redirect = auth_redirect
        @auth_id=auth_id
        super(app, :campus, options)
      end

      # redirect to the Campus website
      def request_phase
        r = Rack::Response.new
        r.redirect @auth_redirect
        r.finish
      end

      def callback_phase
        uid, username, email, token = request.params["uid"], request.params["username"], request.params["email"], request.params["token"]
        sha1 = Digest::SHA1.hexdigest("a mix of #{uid} #{@secret}, #{@auth_id}, #{username}, #{email}")

        # check if the request comes from Campus or not
        if sha1 == token
          @uid, @username, @email = uid, username, email
          # OmniAuth takes care of the rest
	        super
        else
        # OmniAuth takes care of the rest
          fail!(:invalid_credentials)
        end
      end

      # normalize user's data according to http://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      def auth_hash
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => @uid,
          'user_info' => {
            'name'     => @username,
            'nickname' => @username,
            'email'    => @email
          }
        })
      end
    end
  end
end