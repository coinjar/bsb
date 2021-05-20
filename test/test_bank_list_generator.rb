require 'minitest/autorun'
require 'bsb/bank_list_generator'

module BSB
  class BankListGeneratorTest < Minitest::Test
    def test_load_file
      stub_request(:get, "https://somewhere/some.csv")
        .to_return(status: 200, body: File.read('test/fixtures/BSBDirectoryApr21-301.csv'))

      list = BSB::BankListGenerator.load_file('https://somewhere/some.csv')
      hash = JSON.parse(list.json)
      assert hash['ANZ Smart Choice'] == 'ANZ'
    end
  end
end
