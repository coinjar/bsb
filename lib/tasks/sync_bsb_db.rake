# frozen_string_literal: true

require 'bsb'
require 'bsb/database_generator'

namespace :bsb do
  desc 'Sync config/bsb_db.json with data provided by AusPayNet'
  task :sync_bsb_db do
    latest_db = BSB::DatabaseGenerator.fetch_latest
    existing_db_hash = JSON.parse(File.read(BSB::DB_FILEPATH))
    latest_db_hash = latest_db.hash

    deletions = existing_db_hash.reject { |bsb, _| latest_db_hash.key?(bsb) }
    additions = latest_db_hash.reject { |bsb, _| existing_db_hash.key?(bsb) }
    modifications = {}

    latest_db_hash.each do |bsb, data|
      next unless existing_db_hash.key?(bsb) && existing_db_hash[bsb] != data

      modifications[bsb] = data
    end

    changes_json = JSON.pretty_generate(
      {
        additions: additions,
        deletions: deletions,
        modifications: modifications
      }
    )

    File.write(BSB::DB_FILEPATH, latest_db.json(sorted: true))
    File.write(BSB::CHANGES_FILEPATH, changes_json)
  end
end
