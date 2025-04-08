# frozen_string_literal: true

require 'json'

module BSB
  class BaseGenerator
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def json(sorted: false)
      return JSON.pretty_generate(@hash) unless sorted

      JSON.pretty_generate(@hash.sort.to_h)
    end
  end
end
