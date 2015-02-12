if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'minitest/autorun'

require 'unschema'

class TestCase <  Minitest::Test
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
    if match = %r{^\s*}.match(first_line)
      match.end(0)
    else
      0
    end
  end

  def indent(level)
    gsub(%r{^}, " " * level)
  end
end
