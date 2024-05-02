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
      files = @ftp.nlst.select do |f|
        f.include?(matching_filename) && f.end_with?(file_format)
      end

      files.sort_by { |fname| @ftp.mtime(fname) }
    ensure
      @ftp.chdir('/')
    end
  end
end
