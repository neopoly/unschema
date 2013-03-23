require 'minitest/autorun'

require 'unschema'

class TestCase <  MiniTest::Unit::TestCase
end

class String
  def unindent
    matched = %r{^\s*}.match self.split("\n").first
    indent = matched.end(0)
    self.gsub(%r{^\s{#{indent}}}, '')
  end
end
