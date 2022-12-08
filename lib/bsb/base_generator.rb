# frozen_string_literal: true

require 'json'
require 'auspaynet/client'

module BSB
  class BaseGenerator
    def initialize(hash)
      @hash = hash
    end

    def json
      JSON.pretty_generate(@hash)
    end

    def self.latest_file(matching_filename:, file_format:)
      client = ::Auspaynet::Client.new('bsb.hostedftp.com')
      client.list(dir: '~auspaynetftp/BSB', matching_filename: matching_filename, file_format: file_format)&.last
    end
  end
end
