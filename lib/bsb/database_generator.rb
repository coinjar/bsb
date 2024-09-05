# frozen_string_literal: true

require 'bsb/base_generator'
require 'faraday'

module BSB
  class DatabaseGenerator < BaseGenerator
    LEADER_WIDTH = 41

    def self.load_file(filename)
      hash = {}
      File.foreach(filename) do |line|
        next if line[3] != '-'

        bsb = line[0, 3] + line[4, 3]
        hash[bsb] =
          [line[7, 3], line[10, 35].strip, line[45, 35].strip, line[80, 20].strip, line[100, 3].strip, line[103, 4],
           line[107, 3]]
      end
      new(hash)
    end

    def self.fetch_latest
      conn = Faraday.new(
        url: 'https://auspaynet-bicbsb-api-prod.azure-api.net',
        headers: {
          'Content-Type': 'application/json',
          'Ocp-Apim-Subscription-Key': ENV.fetch('AUSPAYNET_SUB_KEY', nil)
        }
      )

      response = conn.post('/bsbquery/manual/paths/invoke') do |req|
        # Just following AusPayNet's recommendation with the formatting of this param. It's a required field
        # as well.
        req.body = { outputparam: ' ' * (LEADER_WIDTH - 11) }.to_json
      end

      hash = {}
      results = JSON.parse(response.body[LEADER_WIDTH..])
      results.each do |bsb_config|
        bsb = bsb_config.fetch('BSBCode').delete('-')
        hash[bsb] = [
          bsb_config.fetch('FiMnemonic'),
          bsb_config.fetch('BSBName'),
          bsb_config.fetch('Address'),
          bsb_config.fetch('Suburb'),
          bsb_config.fetch('State'),
          bsb_config.fetch('Postcode'),
          'PEH'.chars.map { bsb_config.fetch('StreamCode').include?(_1) ? _1 : ' ' }.join
        ]
      end
      new(hash)
    end
  end
end
