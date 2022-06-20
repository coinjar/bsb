# frozen_string_literal: true

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

    def list(dir:, matching_filename:, file_format: 'csv')
      @ftp.chdir(dir)
      files = @ftp.nlst.select! { |f| f.include?(matching_filename) && f.include?(file_format) }
      files.sort_by! { |filename| @ftp.mtime(filename) }
    ensure
      @ftp.chdir('/')
    end
  end
end
