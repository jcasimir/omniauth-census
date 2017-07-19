require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Census < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      def self.provider_endpoint
        
        if ENV['CENSUS_ENV'] == 'production' || ENV['RACK_ENV'] == 'production'
          return "https://turing-census.herokuapp.com"
        else
          return "https://census-app-staging.herokuapp.com"
        end
        
      end

      option :client_options, {
         site: provider_endpoint,
         authorize_url: "/oauth/authorize",
         token_url: "/oauth/token"
       }

      def request_phase
        super
      end

      def callback_url
        full_host + script_name + callback_path
      end

      info do
        raw_info.merge("token" => access_token.token)
      end

      uid { raw_info["id"] }

      def raw_info
        @raw_info ||=
          access_token.get('/api/v1/user_credentials').parsed
      end

    end
  end
end
