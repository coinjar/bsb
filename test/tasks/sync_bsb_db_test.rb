# frozen_string_literal: true

require 'test_helper'
require 'rake'
require 'bsb/database_generator'

describe 'sync_bsb_db rake task' do # rubocop:disable Metrics/BlockLength
  before do
    BSB::DB_FILEPATH = 'test/tmp/bsb_db.json'
    BSB::DatabaseGenerator::LEADER_WIDTH = 0
    Rake.application.rake_require('../lib/tasks/sync_bsb_db')
    File.write(BSB::DB_FILEPATH, File.read('test/fixtures/bsb_db.json'))
  end

  after do
    Dir.glob('test/tmp/**/*.json').each { File.delete(_1) }
  end

  let(:faraday_response) do
    JSON.dump(
      [
        {
          BSBCode: '123-456',
          BSBName: 'Aviato',
          FiMnemonic: 'TST',
          Address: '123 Fake Street',
          Suburb: 'Dubbo',
          State: 'NSW',
          Postcode: '1234',
          StreamCode: 'EH',
          lastmodified: nil,
          BIC: 'TSTAAU2SSYD',
          BICINT: '',
          repair: '00'
        },
        {
          BSBCode: '987-654',
          BSBName: 'Aviato2',
          FiMnemonic: 'EST',
          Address: '123 Faker Street',
          Suburb: 'Ballina',
          State: 'QLD',
          Postcode: '1234',
          StreamCode: 'P',
          lastmodified: nil,
          BIC: 'TSTAAU2SSYD',
          BICINT: '',
          repair: '00'
        }
      ]
    )
  end

  let(:expected_db) do
    JSON.pretty_generate(
      {
        '123456': [
          'TST',
          'Aviato',
          '123 Fake Street',
          'Dubbo',
          'NSW',
          '1234',
          ' EH'
        ],
        '987654': [
          'EST',
          'Aviato2',
          '123 Faker Street',
          'Ballina',
          'QLD',
          '1234',
          'P  '
        ]
      }
    )
  end

  it 'generates the expected bsb_db' do
    mock = Minitest::Mock.new
    mock.expect(:post, mock, [String])
    mock.expect(:body, faraday_response, [])
    Faraday.stub(:new, mock) do
      Rake::Task['bsb:sync_bsb_db'].invoke
      resultant_db = File.read(BSB::DB_FILEPATH).strip
      assert_equal(resultant_db, expected_db)
    end
  end
end
