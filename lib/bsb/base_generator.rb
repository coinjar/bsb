# frozen_string_literal: true

require 'json'

module BSB
  class BaseGenerator
    def initialize(hash)
      @hash = hash
    end

    def json
      JSON.pretty_generate(@hash)
    end
  end
end
