require 'test_helper'

describe BSB do
  it '.lookup' do
    details = {:bsb=>"092009", :mnemonic=>"RBA", :bank_name=>"Reserve Bank of Australia", :branch=>"Canberra", :address=>"20-22 London Circuit", :suburb=>"Canberra", :state=>"ACT", :postcode=>"2601", :flags=>{:paper=>true, :electronic=>true, :high_value=>true}}

    assert_equal details, BSB.lookup('092009')
  end

  it '.bank_name' do
    assert_equal 'Reserve Bank of Australia', BSB.bank_name('092009')
  end

  it '.normalize' do
    assert_equal '092009', BSB.normalize(' 092009 ')
  end
end
