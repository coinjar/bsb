# frozen_string_literal: true

namespace :bsb do
  desc 'Generate JSON-formatted database from APCA BSB directory'
  task :generate_database do
    require 'bsb/database_generator'
    if filename = ENV['filename']
      warn 'Loading BSB file from APCA FTP server... (This may take a while)'
      bsb_db_gen = BSB::DatabaseGenerator.load_file(filename)
      puts bsb_db_gen.json
    else
      warn 'Filename variable must be passed. For example, `rake bsb:generate_database filename=BSBDirectoryMay22-314.txt > config/bsb_db.json`'
    end
  end

  desc 'Generate JSON-formatted bank list from APCA BSB directory'
  task :generate_bank_list do
    require 'bsb/bank_list_generator'
    if filename = ENV['filename']
      warn 'Loading Bank List file... (This may take a while)'
      bsb_bl_gen = BSB::BankListGenerator.load_file(filename)
      puts bsb_bl_gen.json
    else
      warn "URL variable must be passed. For example, `rake bsb:generate_bank_list filename='KEY TO ABBREVIATIONS AND BSB NUMBERS (May 2022).csv' > config/bsb_bank_list.json`"
    end
  end

  desc 'Sync database and bank list'
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

    system "rake bsb:generate_bank_list filename='#{bank_list_filename}' > config/bsb_bank_list.json"
    system "rake bsb:generate_database filename='#{db_list_filename}' > config/bsb_db.json"
  end

  desc 'version update'
  task :version_update do
    version_file_path = File.join(File.dirname(File.dirname(__FILE__)), 'bsb', '.current-version')
    current_version = File.read(version_file_path).strip
    versions = current_version.split('.')
    patch_version = versions.pop.to_i
    versions.push(patch_version + 1)
    current_version = versions.join(".")
    File.write(version_file_path, current_version)
  end
end
