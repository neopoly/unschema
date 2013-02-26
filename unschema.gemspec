# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unschema/version'

Gem::Specification.new do |gem|
  gem.name          = "unschema"
  gem.version       = Unschema::VERSION
  gem.authors       = ["Jakob Holderbaum"]
  gem.email         = ["jh@neopoly.de"]
  gem.description   = %q{Splits your current schema.rb into per-table migrations. Think of it as >rebase< for your migrations.}
  gem.summary       = %q{Splits your current schema.rb into per-table migrations}
  gem.homepage      = "https://github.com/neopoly/unschema"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency  'rake'
end
