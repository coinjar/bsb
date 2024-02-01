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

    raise 'No bank list or bsb found' unless bank_list_filename || db_list_filename

    puts "Bank list file: '#{bank_list_filename}'"
    puts "DB file: '#{db_list_filename}'"

    if bank_list_filename
      require 'bsb/bank_list_generator'
      bsb_bl_gen = BSB::BankListGenerator.load_file(bank_list_filename)
      File.write('config/bsb_bank_list.json', bsb_bl_gen.json)
    else
      warn 'Missing bank list "KEY TO ABBREVIATIONS AND BSB NUMBERS"'
    end

    if db_list_filename
      require 'bsb/database_generator'
      bsb_db_gen = BSB::DatabaseGenerator.load_file(db_list_filename)
      File.write('config/bsb_db.json', bsb_db_gen.json)
    else
      warn 'Missing bsb db "BSBDirectory"'
    end
  end
end
