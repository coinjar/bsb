# frozen_string_literal: true

require 'test_helper'
require 'rake'
require 'bsb/database_generator'

describe 'sync_bsb_db rake task' do # rubocop:disable Metrics/BlockLength
  before do
    @old_sub_key = ENV.fetch('AUSPAYNET_SUB_KEY', nil)
    ENV.update('AUSPAYNET_SUB_KEY' => 'something')
    Rake.application.rake_require('../lib/tasks/sync_bsb_db')
    Rake::Task['bsb:sync_bsb_db'].reenable
    File.write('test/tmp/bsb_db.json', File.read('test/fixtures/bsb_db.json'))
  end

  after do
    ENV['AUSPAYNET_SUB_KEY'] = @old_sub_key
  end

  let(:auspaynet_bsb_client_response) do
    BSB::AusPayNet::Client::Response.new(
      body: JSON.dump(
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
            State: 'NSW',
            Postcode: '1234',
            StreamCode: 'P',
            lastmodified: nil,
            BIC: 'TSTAAU2SSYD',
            BICINT: '',
            repair: '00'
          }
        ]
      )
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
          'NSW',
          '1234',
          'P  '
        ]
      }
    )
  end

  let(:expected_changes) do
    JSON.pretty_generate(
      {
        additions: {
          '123456': [
            'TST',
            'Aviato',
            '123 Fake Street',
            'Dubbo',
            'NSW',
            '1234',
            ' EH'
          ]
        },
        deletions: {
          '333333': [
            'AAA',
            'Aviato3',
            '123 Fakest Street',
            'Canberra',
            'ACT',
            '1234',
            'P H'
          ]
        },
        modifications: {
          '987654': [
            'EST',
            'Aviato2',
            '123 Faker Street',
            'Ballina',
            'NSW',
            '1234',
            'P  '
          ]
        }
      }
    )
  end

  it 'generates the expected bsb_db and changes file' do
    BSB.stub_consts(DB_FILEPATH: 'test/tmp/bsb_db.json', CHANGES_FILEPATH: 'test/tmp/latest_update.json') do
      BSB::AusPayNet::Client.stub(:fetch_all_bsbs, auspaynet_bsb_client_response) do
        Rake::Task['bsb:sync_bsb_db'].invoke
      end

      resultant_db = File.read(BSB::DB_FILEPATH).strip
      resultant_changes = File.read(BSB::CHANGES_FILEPATH).strip
      assert_equal(resultant_db, expected_db)
      assert_equal(resultant_changes, expected_changes)
    end
  end

  describe 'when the AUSPAYNET_SUB_KEY env var is not set' do
    before do
      ENV.delete('AUSPAYNET_SUB_KEY')
    end

    it 'raises the expected error' do
      assert_raises BSB::AusPayNet::Client::MissingSubscriptionKeyError do
        Rake::Task['bsb:sync_bsb_db'].invoke
      end
    end
  end
end
