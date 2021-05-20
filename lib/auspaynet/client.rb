require 'net/ftp'

module Auspaynet
  class Client
    def initialize(host)
      @host = host
      @ftp = Net::FTP.new(@host)
      @ftp.login
      @ftp.passive = true
    end

    def get(dir, filename)
      @ftp.chdir(dir)
      @ftp.gettextfile(filename, nil)
    ensure
      @ftp.chdir('/')
    end
  end
end
