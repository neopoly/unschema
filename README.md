[github]: https://github.com/neopoly/unschema
[doc]: http://rubydoc.info/github/neopoly/unschema/master/file/README.md
[gem]: https://rubygems.org/gems/unschema
[travis]: https://travis-ci.org/neopoly/unschema
[codeclimate]: https://codeclimate.com/github/neopoly/unschema
[inchpages]: https://inch-ci.org/github/neopoly/unschema

# Unschema - rebase your schema.rb

Splits your schema.rb into separate migrations per table.

[![Travis](https://img.shields.io/travis/neopoly/unschema.svg?branch=master)][travis]
[![Gem Version](https://img.shields.io/gem/v/unschema.svg)][gem]
[![Code Climate](https://img.shields.io/codeclimate/github/neopoly/unschema.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/neopoly/unschema/badges/coverage.svg)][codeclimate]
[![Inline docs](https://inch-ci.org/github/neopoly/unschema.svg?branch=master&style=flat)][inchpages]

[Gem][gem] |
[Source][github] |
[Documentation][doc]

Every table migration contains a create_table and additional add_index calls.

We use it to cleanup older projects, that gets reused as codebase for new projects.

## Installation

Add this line to your application's Gemfile:

    gem 'unschema', '~> 0.2.0'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unschema

## Usage

    usage: unschema [SCHEMA_FILE] [MIGRATIONS_DIR] [RAILS_VERSION]

## TODO

* Auto-detect Rails directory and use correct defaults.
* Generate prettier migrations (ident, options hashes, newlines)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Release

Follow these steps to release this gem:

    # Bump version in
    edit lib/unschema/version.rb
    edit README.md

    git commit -m "Release X.Y.Z"

    rake release
