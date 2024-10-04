# frozen_string_literal: true

require("faraday")

module BSB
  module AusPayNet
    module Client
      class MissingSubscriptionKeyError < StandardError; end

      OUTPUT_PARAM_WIDTH = 30
      LEADER_WIDTH = OUTPUT_PARAM_WIDTH + 11

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
        end

        response = conn.post('/bsbquery/manual/paths/invoke') do |req|
          req.body = { outputparam: ' ' * OUTPUT_PARAM_WIDTH }.to_json
        end

        Response.new(body: response.body[LEADER_WIDTH..])
      end
    end
  end
end
