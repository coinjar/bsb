# frozen_string_literal: true

require 'bsb/aus_pay_net/client'
require 'test_helper'

describe BSB::AusPayNet::Client do
  describe '.fetch_all_bsbs' do
    before do
      if ENV['AUSPAYNET_SUB_KEY'].nil?
        @remove_auspay_key = true
        ENV['AUSPAYNET_SUB_KEY'] = 'something'
      end
    end

    after do
      ENV.delete('AUSPAYNET_SUB_KEY') if @remove_auspay_key
    end

    it 'returns the expected response' do
      VCR.use_cassette('auspaynet_fetch_all_bsbs') do
        response = BSB::AusPayNet::Client.fetch_all_bsbs
        assert_equal(response.class, BSB::AusPayNet::Client::Response)
        assert_equal(response.body.class, String)
        assert_equal(JSON.parse(response.body).count, 2)
      end
    end
  end
end
