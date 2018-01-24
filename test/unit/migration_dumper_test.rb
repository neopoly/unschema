require 'stringio'
require 'helper'

class MigrationDumperTest < TestCase
  def test_without_calls
    create_dumper(rails_version: "5.1")

    inner = <<-STR
    STR
    assert_change inner, rails_version: "5.1"
  end

  def test_create_table_call
    create_dumper \
      create_call(:create_table, "table", :force => true) { |t|
        t.string "uid", :limit => 32, :unique => true
        t.integer "amount"
      },
      rails_version: "5.1"

    assert_change <<-STR
      create_table "table", :force => true do |t|
        t.string "uid", :limit => 32, :unique => true
        t.integer "amount"
      end
    STR
  end

  def test_index_call
    create_dumper \
      create_call(:add_index, "table", "uid", :unique => true),
      create_call(:add_index, "table", %w[composite index]),
      rails_version: "5.1"

    assert_change <<-STR
      add_index "table", "uid", :unique => true
      add_index "table", ["composite", "index"]
    STR
  end

  private

  def create_dumper(*calls, rails_version:)
    @dumper = Unschema::MigrationDumper.new("foo_bar", calls, rails_version: rails_version)
  end

  def create_call(name, *args, &block)
    Unschema::SchemaIntermediator::Call.new(name, *args, &block)
  end

  def assert_change(inner, rails_version: "5.1")
    expect = <<-STR
      class CreateFooBar < ActiveRecord::Migration[#{rails_version}]
        def change
    STR

    unless inner.empty?
      expect << inner.unindent.indent(expect.indentation + 4)
    end

    expect << <<-STR
        end
      end
    STR

    assert_dump expect
  end

  def assert_dump(expect)
    io = StringIO.new
    @dumper.dump_to(io)
    assert_string io.string, expect
  end
end
