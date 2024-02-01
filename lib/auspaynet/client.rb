# frozen_string_literal: true

require 'net/ftp'

module Auspaynet
  class Client
    MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

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
        f.include?(matching_filename) &&
          f.include?(file_format) &&
          (f.include?("#{current_year}-") || f.include?("#{current_year})"))
      end

      extract_latest_files(files: files, file_format: file_format)
    ensure
      @ftp.chdir('/')
    end

    private

    def current_year
      Time.now.strftime('%y')
    end

    def extract_latest_files(files:, file_format:)
      files.sort_by do |filename|
        file_for_month(filename: filename, file_format: file_format)
      end
    end

    def file_for_month(filename:, file_format:)
      month_from_filename = filename.gsub(/(#{filename}|#{file_format}|\W|\d)/, '')
      month_number(month_from_filename)
    end

    def month_number(month_from_filename)
      MONTHS.find_index(month_from_filename)
    end
  end
end
