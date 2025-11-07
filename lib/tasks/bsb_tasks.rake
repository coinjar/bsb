# frozen_string_literal: true

require 'bsb'
require 'bsb/database_generator'
require 'bsb/bank_list_generator'

require 'fileutils'
require 'faraday/follow_redirects'

namespace :bsb do
  desc 'Sync config/*.json.'
  task :sync_bsb_db_manual, [:bsbfile] do |_t, args|
    db_list_filename = args[:bsbfile]

    if db_list_filename
      bsb_db_gen = BSB::DatabaseGenerator.load_file(db_list_filename)
      File.write(BSB::DB_FILEPATH, bsb_db_gen.json)
    else
      warn 'Missing bsb db "BSBDirectory"'
    end
  end

  desc 'Sync bank list from a keyfile'
  task :sync_bank_list, [:keyfile] do |_t, args|
    bank_list_filename = args[:keyfile]

    if bank_list_filename
      bsb_bl_gen = BSB::BankListGenerator.load_file(bank_list_filename)
      File.write('config/bsb_bank_list.json', bsb_bl_gen.json)
    else
      warn 'Missing bank list "KEY TO ABBREVIATIONS AND BSB NUMBERS"'
    end
  end

  desc 'Fetch the BSB CSV from AusPayNet (default output: tmp/key.csv)'
  task :fetch_key_file, [:output_path] do |_t, args|
    args.with_defaults(output_path: 'tmp/key.csv')

    url = 'https://bsb.auspaynet.com.au/Public/BSB_DB.NSF/getKeytoACSV?OpenAgent'
    user_agent = 'CoinJarBSBUpdater/1.0 (https://github.com/coinjar/bsb)'

    puts "Fetching CSV from #{url}..."

    response = Faraday.new(url: url) do |f|
      f.headers['User-Agent'] = user_agent
      f.response :raise_error
      f.response :follow_redirects
      f.adapter Faraday.default_adapter
    end.get

    csv_data = response.body

    output_path = args[:output_path]
    FileUtils.mkdir_p(File.dirname(output_path))
    File.binwrite(output_path, csv_data)

    puts "Saved CSV to #{output_path}"
  end
end
