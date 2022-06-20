require 'json'
require 'csv'
require 'auspaynet/client'

module BSB
  class BankListGenerator
    def initialize(hash)
      @hash = hash
    end

    def json
      JSON.dump(@hash)
    end

    def self.load_file(filename)
      client = ::Auspaynet::Client.new('bsb.hostedftp.com')
      content = client.get('~auspaynetftp/BSB', filename)
      hash = {}
      CSV.parse(content) do |row|
        row[2].split(", ").each do |prefix|
          prefix = prefix.chomp.rjust(2, "0")
          hash[prefix] = row[1]
        end
      end
      new(hash)
    end

    def self.latest_file(matching_filename:, file_format:)
      client = ::Auspaynet::Client.new('bsb.hostedftp.com')
      client.list(dir: '~auspaynetftp/BSB', matching_filename:, file_format:)&.last
    end
  end
end
