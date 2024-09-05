# frozen_string_literal: true

require 'bsb'
require 'bsb/database_generator'

namespace :bsb do
  desc 'Sync config/bsb_db.json with data provided by AusPayNet'
  task :sync_bsb_db do
    latest_db = BSB::DatabaseGenerator.fetch_latest
    File.write(BSB::DB_FILEPATH, latest_db.json)
  end
end
