# frozen_string_literal: true

require 'bsb/version'
require 'json'
require 'bsb_number_validator'

module BSB
  DB_FILEPATH = 'config/bsb_db.json'
  CHANGES_FILEPATH = 'config/latest_update.json'
  class << self
    def lookup(number)
      bsb = normalize(number)
      array = data_hash[bsb]
      return nil if array.nil?

      {
        bsb: bsb,
        mnemonic: array[0],
        bank_name: bank_name(bsb),
        branch: array[1],
        address: array[2],
        suburb: array[3],
        state: array[4],
        postcode: array[5],
        flags: {
          paper: (array[6][0] == 'P'),
          electronic: (array[6][1] == 'E'),
          high_value: (array[6][2] == 'H')
        }
      }
    end

    def bank_name(bsb)
      bank_list.each do |prefix, bank_name|
        return bank_name if bsb.start_with? prefix
      end
      nil
    end

    def normalize(str)
      str.gsub(/[^\d]/, '')
    end

    protected

    def data_hash
      @data_hash ||= JSON.parse(File.read(File.expand_path('../config/bsb_db.json', __dir__)))
    end

    def bank_list
      @bank_list ||= JSON.parse(File.read(File.expand_path('../config/bsb_bank_list.json', __dir__)))
    end
  end
end
