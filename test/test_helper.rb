# frozen_string_literal: true

require 'bsb'
require 'minitest/autorun'
require 'minitest/stub_const'
require 'vcr'

Minitest.after_run do
  Dir.glob('test/tmp/**/*.json').each { File.delete(_1) }
end

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :faraday
  config.filter_sensitive_data('<AUSPAYNET_SUB_KEY>') do |interaction|
    if interaction.request.headers['Ocp-apim-subscription-key']
      interaction.request.headers['Ocp-apim-subscription-key'][0]
    end
  end
end

class Account
  include ActiveModel::API

  attr_accessor :bsb, :account_number, :account_name

  validates :bsb, :account_number, :account_name, presence: true
  validates :bsb, length: { is: 6 }, bsb_number: true
end
