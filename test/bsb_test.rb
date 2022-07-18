# frozen_string_literal: true

require 'test_helper'

describe BSB do
  it '.lookup' do
    details = {
      bsb: '092009', mnemonic: 'RBA', bank_name: 'Reserve Bank of Australia',
      branch: 'Canberra', address: '20-22 London Circuit', suburb: 'Canberra',
      state: 'ACT', postcode: '2601', flags: { paper: true, electronic: true,
                                               high_value: true }
    }

    assert_equal details, BSB.lookup('092009')
  end

  it '.bank_name' do
    assert_equal 'Reserve Bank of Australia', BSB.bank_name('092009')
  end

  it '.normalize special char' do
    assert_equal '083004', BSB.normalize('083-004')
  end

  it '.normalize whitespace' do
    assert_equal '062000', BSB.normalize('06 2000')
  end
end
