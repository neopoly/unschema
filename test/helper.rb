require 'minitest/autorun'

require 'unschema'

class TestCase <  MiniTest::Unit::TestCase
  def assert_string(actual, expect)
    assert_equal expect.unindent.chomp, actual.unindent
  end
end

class String
  def unindent
    matched = %r{^\s*}.match self.split("\n").first
    indent = matched.end(0)
    self.gsub(%r{^\s{#{indent}}}, '')
  end
end
