# frozen_string_literal: true

require 'test_helper'

describe BsbNumberValidator do
  it '#valid?' do
    assert_equal true, Account.new(bsb: '092009', account_number: '218963243', account_name: 'Bruce Wayne').valid?
    assert_equal false, Account.new(bsb: '000001', account_number: '218963243', account_name: 'Bruce Wayne').valid?
  end
end
