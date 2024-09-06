# frozen_string_literal: true

require 'bsb'
require 'minitest/autorun'
require 'minitest/stub_const'

Minitest.after_run do
  Dir.glob('test/tmp/**/*.json').each { File.delete(_1) }
end

class Account
  include ActiveModel::API

  attr_accessor :bsb, :account_number, :account_name

  validates :bsb, :account_number, :account_name, presence: true
  validates :bsb, length: { is: 6 }, bsb_number: true
end
