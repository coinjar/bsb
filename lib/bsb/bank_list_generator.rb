# frozen_string_literal: true

require 'csv'
require 'bsb/base_generator'

module BSB
  class BankListGenerator < BaseGenerator
    def self.load_file(filename)
      hash = {}
      CSV.foreach(filename) do |row|
        row[2].split(', ').each do |prefix|
          prefix = prefix.chomp.rjust(2, '0')
          hash[prefix] = row[1]
        end
      end
      new(hash)
    end
  end
end
