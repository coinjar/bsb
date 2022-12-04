require 'json'

module BSB
  class DatabaseGenerator
    def initialize(hash)
      @hash = hash
    end

    def json
      JSON.pretty_generate(@hash)
    end

    def self.load_file(filename)
      require 'net/ftp'
      ftp = Net::FTP.new('bsb.hostedftp.com')
      ftp.login
      ftp.passive = true
      ftp.chdir('~auspaynetftp/BSB')

      filelist = ftp.list(filename, nil)
      filename = filelist.first.split.last if filelist.size == 1

      content = ftp.gettextfile(filename, nil)
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
