# frozen_string_literal: true

require 'bsb/base_generator'
require 'bsb/aus_pay_net/client'
require 'faraday'

module BSB
  class DatabaseGenerator < BaseGenerator
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
      response = BSB::AusPayNet::Client.fetch_all_bsbs

      hash = {}
      JSON.parse(response.body).each do |bsb_config|
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
