# The BSB Gem

A Bank State Branch (BSB) number is a code that identifies banks and branches in Australia. This gem provides an easy-to-use lookup utility and an ActiveModel validator for use in any Rails project.

This gem aims to provide a scalable and developer-friendly solution for BSB lookup and validation. If you are building a financial application targeting Australian customers, properly validating BSB numbers is an essential component of a hassle-free user experience.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bsb'
```

And then execute:

    $ bundle

## Usage

### BSB Lookup

To lookup a BSB number:

```
BSB.lookup "012003"
```

You will get a hash back, including the highly-useful full bank name which can be displayed to the user:

```ruby
{:bsb=>"012003", :mnemonic=>"ANZ", :bank_name=>"Australia & New Zealand Banking Group Limited", :branch=>"115 Pitt St Sydney", :address=>"115 Pitt St", :suburb=>"Sydney", :state=>"NSW", :postcode=>"2000", :flags=>{:paper=>true, :electronic=>true, :high_value=>true}}
```

BSB lookup with this gem is extremely performant. A decent MacBook Pro can easily run 100,000 lookups a second.

### Normalisation

There's a public method for you to normalise a BSB number from a variety of formats, for example:

```ruby
> BSB.normalize "083-004"
=> "083004"

> BSB.normalize "06 2000"
=> "062000"
```

### ActiveModel Validator

If you have included this gem in your Rails project, you can use the custom validator `bsb_number`. For example, in your model:

```ruby
validates :bsb, :account_number, :account_name, presence: true
validates :bsb, length: { is: 6 }, bsb_number: true
```

This validator ensures that the BSB number entered by the user actually exists.

## Data source

Included in this gem is also a set of Rake tasks to generate the JSON-formatted compressed database for maximum performance (it's only as readable as the offset data files).

Two data sources are used:

* APCA BSB directory (Updated monthly. This gem will track the changes and push gem updates as frequently as my time allows.)
* APCA Key to Abbreviations and BSB Number (No regular updates)

Other formats of APCA BSB data is available from http://bsb.apca.com.au.

## Update BSB Bank List

At the moment BSB data is a manual download from the Auspaynet site [here](https://bsb.auspaynet.com.au/).

You will need to download two files, place them in `tmp/`:
- `Reference Documents` button > `Key to Abbreviations and BSB Number` in CSV format.

Run the sync task with the files to complete sync of the latest data:

```sh
rake bsb:sync_bank_list_['tmp/key to abbreviations and bsb numbers (august 2024).csv']
```

Browse the list of database changes, make a few queries on the website to ensure the results are the same.

## Update BSB DB

`config/bsb_db.json` can be updated by running the `bsb:sync_bsb_db` rake task.
This task depends on you having you having an Aus Pay Net API subscription and key and that key being available in the
`AUSPAYNET_SUB_KEY` environment variable.

You can apply for an API subscription and key by visiting [AusPayNet's bsb page](https://bsb.auspaynet.com.au/),
clicking the `API Registration` button and following the prompts.

Once you have a key, the task can be run as follows

```sh
AUSPAYNET_SUB_KEY="your_key_here" rake bsb:sync_bsb_db
```

This will update the `config/bsb_db.json` file with the latest information and will produce a
`config/latest_update.json` file that contains a breakdown of additions, deletions and modifications to make spot
checking results easier.

Browse the list of database changes, make a few queries on the website to ensure the results are the same.

## Update BSB DB (Manual)

BSB DB data can be downloaded manually from the Auspaynet site [here](https://bsb.auspaynet.com.au/).

You will need to download two files, place them in `tmp/`:
- `Download BSB Files` button > `BSB Directory (Full Version)` in TEXT format.

Run the sync task with the files to complete sync of the latest data:

```sh
rake bsb:sync_bsb_db_manual['tmp/BSBDirectoryAug24-341.txt']
```

Browse the list of database changes, make a few queries on the website to ensure the results are the same.

## Contributing

1. Fork it ( https://github.com/zhoutong/bsb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
