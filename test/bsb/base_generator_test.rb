# frozen_string_literal: true

require 'test_helper'
require 'bsb/base_generator'

describe BSB::BaseGenerator do
  describe '#json' do
    it 'returns a JSON string' do
      hash = { key: 'value' }
      generator = BSB::BaseGenerator.new(hash)
      expected_json = <<~JSON.strip
        {
          "key": "value"
        }
      JSON

      assert_equal expected_json, generator.json
    end

    it 'returns a JSON representation of the sorted hash when sorted is true' do
      hash = { '123456' => '3', '012345' => '2', '234567' => '4', '00001' => '1' }
      generator = BSB::BaseGenerator.new(hash)
      expected_json = <<~JSON.strip
        {
          "00001": "1",
          "012345": "2",
          "123456": "3",
          "234567": "4"
        }
      JSON

      assert_equal expected_json, generator.json(sorted: true)
    end

    it 'returns a JSON representation of the unsorted hash when sorted is false' do
      hash = { '123456' => '3', '012345' => '2', '234567' => '4', '00001' => '1' }
      generator = BSB::BaseGenerator.new(hash)
      expected_json = <<~JSON.strip
        {
          "123456": "3",
          "012345": "2",
          "234567": "4",
          "00001": "1"
        }
      JSON

      assert_equal expected_json, generator.json(sorted: false)
    end
  end
end
