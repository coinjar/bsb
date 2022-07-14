# frozen_string_literal: true

namespace :bsb do
  desc 'Sync config/*.json.'
  task :sync do
    require 'bsb/base_generator'
    bank_list_filename = BSB::BaseGenerator.latest_file(
      matching_filename: 'KEY TO ABBREVIATIONS AND BSB NUMBERS',
      file_format: '.csv'
    )
    db_list_filename = BSB::BaseGenerator.latest_file(
      matching_filename: 'BSBDirectory',
      file_format: '.txt'
    )

    require 'bsb/bank_list_generator'
    bsb_bl_gen = BSB::BankListGenerator.load_file(bank_list_filename)
    File.write('config/bsb_bank_list.json', bsb_bl_gen.json)

    require 'bsb/database_generator'
    bsb_db_gen = BSB::DatabaseGenerator.load_file(db_list_filename)
    File.write('config/bsb_db.json', bsb_db_gen.json)
  end
end
