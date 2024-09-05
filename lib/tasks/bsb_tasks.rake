# frozen_string_literal: true

namespace :bsb do
  desc 'Sync config/*.json.'
  task :sync_bsb_db_manual, [:bsbfile] do |_t, args|
    db_list_filename = args[:bsbfile]

    if db_list_filename
      require 'bsb/database_generator'
      bsb_db_gen = BSB::DatabaseGenerator.load_file(db_list_filename)
      File.write('config/bsb_db.json', bsb_db_gen.json)
    else
      warn 'Missing bsb db "BSBDirectory"'
    end
  end
  
  task :sync_bank_list, [:keyfile] do |_t, args|
    bank_list_filename = args[:keyfile]

    if bank_list_filename
      require 'bsb/bank_list_generator'
      bsb_bl_gen = BSB::BankListGenerator.load_file(bank_list_filename)
      File.write('config/bsb_bank_list.json', bsb_bl_gen.json)
    else
      warn 'Missing bank list "KEY TO ABBREVIATIONS AND BSB NUMBERS"'
    end
  end
end
