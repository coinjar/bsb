require 'json'
require 'csv'
require 'net/http'

module BSB
  class BankListGenerator
    def initialize(hash)
      @hash = hash
    end

    def json
      JSON.dump(@hash)
    end

    def self.load_file(filename)
      require 'net/ftp'
      ftp = Net::FTP.new('bsb.hostedftp.com')
      ftp.login
      ftp.passive = true
      ftp.chdir('~auspaynetftp/BSB')
      content = ftp.gettextfile(filename, nil)
      hash = {}
      CSV.parse(content) do |row|
        row[2].split(", ").each do |prefix|
          prefix = prefix.chomp.rjust(2, "0")
          hash[prefix] = row[1]
        end
      end
      new(hash)
    end
  end
end
