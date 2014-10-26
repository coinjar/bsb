namespace :bsb do
  desc "Generate JSON-formatted database from APCA BSB directory"
  task :generate_database do
    require 'bsb/database_generator'
    if filename = ENV['filename']
      STDERR.puts "Loading BSB file from APCA FTP server... (This may take a while)"
      bsb_db_gen = BSB::DatabaseGenerator.load_file(filename)
      puts bsb_db_gen.json
    else
      STDERR.puts "Filename variable must be passed. For example, `rake bsb:generate_database filename=BSBDirectoryOct14-222.txt > config/bsb_db.json`"
    end
  end

  task :generate_bank_list do
    require 'bsb/bank_list_generator'
    if url = ENV['url']
      STDERR.puts "Loading Bank List file... (This may take a while)"
      bsb_bl_gen = BSB::BankListGenerator.load_file(url)
      puts bsb_bl_gen.json
    else
      STDERR.puts "URL variable must be passed. For example, `rake bsb:generate_bank_list url='http://bsb.apca.com.au/public/BSB_DB.NSF/0/9B80EBFA44A993E6CA2579650017682A/$File/key%20to%20abbreviations%20and%20bsb%20numbers%20(july2014).csv' > config/bsb_bank_list.json`"
    end
  end
end
