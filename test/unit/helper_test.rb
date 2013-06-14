require 'helper'

class HelperTest < TestCase
  def test_unindent
    expect = <<-STR
foo
  bar
    STR
    actual = <<-STR
  foo
    bar
    STR

    assert_equal expect, actual.unindent
  end

  def test_indent
    expect = <<-STR
  foo
  bar
    STR
    actual = <<-STR
foo
bar
    STR

    assert_equal expect, actual.indent(2)
  end
end
