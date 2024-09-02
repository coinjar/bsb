# frozen_string_literal: true

require 'bsb/base_generator'

module BSB
  class DatabaseGenerator < BaseGenerator
    def self.load_file(filename)
      hash = {}
      File.foreach(filename) do |line|
        next if line[3] != '-'

        bsb = line[0, 3] + line[4, 3]
        hash[bsb] =
          [line[7, 3], line[10, 35].strip, line[45, 35].strip, line[80, 20].strip, line[100, 3].strip, line[103, 4],
           line[107, 3]]
      end
      new(hash)
    end
  end
end
