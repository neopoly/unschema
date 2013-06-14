require 'minitest/autorun'

require 'unschema'

class TestCase <  MiniTest::Unit::TestCase
  def assert_string(actual, expect)
    assert_equal expect.unindent.chomp, actual.unindent
  end
end

class String
  def unindent
    gsub(%r{^\s{#{indentation}}}, '')
  end

  def indentation
    first_line = split("\n").first
    %r{^\s*}.match(first_line).end(0)
  end

  def indent(indentation)
    gsub(%r{^}, indentation)
  end
end
