# frozen_string_literal: true

require("faraday")

module BSB
  module AusPayNet
    module Client
      class MissingSubscriptionKeyError < StandardError; end

      Response = Struct.new(:body, keyword_init: true)

      def self.fetch_all_bsbs
        subscription_key = ENV.fetch('AUSPAYNET_SUB_KEY', nil)
        if subscription_key.nil?
          raise MissingSubscriptionKeyError, "the environment variable 'AUSPAYNET_SUB_KEY' must be present"
        end

        conn = Faraday.new(
          url: 'https://auspaynet-bicbsb-api-prod.azure-api.net',
          headers: {
            'Content-Type': 'application/json',
            'Ocp-Apim-Subscription-Key': subscription_key
          }
        ) do |faraday|
          faraday.response :raise_error
          faraday.response :json
        end

        response = conn.post('/BSBQuery-V2/manual/paths/invoke')

        Response.new(body: response.body.fetch('data'))
      end
    end
  end
end
