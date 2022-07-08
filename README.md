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

* APCA BSB directory (Updated bi-monthly. This gem will track the changes and push gem updates as frequently as my time allows.)
* APCA Key to Abbreviations and BSB Number (No regular updates)

Other formats of APCA BSB data is available from http://bsb.apca.com.au.

## Update source

Run this `rake bsb:sync` command to complete sync of the latest data

## Contributing

1. Fork it ( https://github.com/zhoutong/bsb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
