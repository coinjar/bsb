# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'sync_bsb_db rake task' do
  before do
    Rake.application.rake_require('../lib/tasks/sync_bsb_db')
    BSB::DB_FILEPATH = "test/tmp/bsb_db.json"
    File.write(BSB::DB_FILEPATH, File.read("test/fixtures/bsb_db.json"))
  end

  after do
    Dir.glob("test/tmp/**/*.json").each { File.delete(_1) }
  end

  let(:expected_db) { JSON.pretty_generate({hey: "there"}) }

  it 'generates the expected bsb_db' do
    Rake::Task["bsb:sync_bsb_db"].invoke

    resultant_db = File.read(BSB::DB_FILEPATH).strip
    assert_equal(resultant_db, expected_db)
  end
end
