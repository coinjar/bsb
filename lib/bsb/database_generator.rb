require 'json'
require 'auspaynet/client'

module BSB
  class DatabaseGenerator
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
      content.each_line do |line|
        next if line[3] != "-"
        bsb = line[0,3] + line[4,3]
        hash[bsb] = [line[7,3], line[10,35].strip, line[45,35].strip, line[80,20].strip, line[100,3].strip, line[103,4], line[107,3]]
      end
      new(hash)
    end
  end
end
