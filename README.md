# Unschema - rebase your schema.rb

[![Build Status](https://travis-ci.org/neopoly/unschema.svg?branch=master)](https://travis-ci.org/neopoly/unschema) [![Gem Version](https://badge.fury.io/rb/unschema.svg)](http://badge.fury.io/rb/unschema) [![Code Climate](https://codeclimate.com/github/neopoly/unschema.svg)](https://codeclimate.com/github/neopoly/unschema)

Splits your schema.rb into separate migrations per table.

Every table migration contains a create_table and additional add_index calls.

We use it to cleanup older projects, that gets reused as codebase for new projects.

## Installation

Add this line to your application's Gemfile:

    gem 'unschema'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unschema

## Usage

    usage: unschema [SCHEMA_FILE] [MIGRATIONS_DIR]

## TODO

* Auto-detect Rails directory and use correct defaults.
* Generate prettier migrations (ident, options hashes, newlines)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
