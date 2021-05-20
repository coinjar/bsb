require 'json'
require 'csv'

module BSB
  class BankListGenerator
    def initialize(hash)
      @hash = hash
    end

    def json
      JSON.dump(@hash)
    end

    def self.load_file(url)
      hash = {}
      response = Net::HTTP.get(URI(url))
      CSV.parse(response) do |row|
        row[2].split(", ").each do |prefix|
          prefix = prefix.chomp.rjust(2, "0")
          hash[prefix] = row[1]
        end
      end
      new(hash)
    end
  end
end
