require 'helper'
require 'fileutils'
require 'pathname'

class EndToEndTest < TestCase
  def setup
    Dir[migrations_path.join "*.rb"].map { |file| File.delete(file) }
  end

  def test_schema_to_migrations
    rails_version = "5.1"
    Unschema::Base.process!(schema_file, migrations_path.to_s, true, rails_version)

    assert_equal ["20130222131356_create_abc.rb", "20130222131357_create_table1.rb", "20130222131358_create_the_table2.rb"], Dir[migrations_path.join "*.rb"].map { |path| File.basename(path) }.sort

    assert_migration "20130222131356_create_abc.rb", <<-MIGRATION
      class CreateAbc < ActiveRecord::Migration[#{rails_version}]
        def change
          create_table "abc" do |t|
            t.string "defgh"
          end
        end
      end
    MIGRATION

    assert_migration "20130222131357_create_table1.rb", <<-MIGRATION
      class CreateTable1 < ActiveRecord::Migration[#{rails_version}]
        def change
          create_table "table1", :force => true do |t|
            t.string "str"
            t.integer "int"
            t.datetime "created_at"
            t.datetime "updated_at"
          end
          add_index "table1", ["id"], :name => "the_index_1", :unique => true
          add_index "table1", ["doesnt_make_sende"], :name => "the_index_2", :unique => true, :wrong_attr => 1
        end
      end
    MIGRATION

    assert_migration "20130222131358_create_the_table2.rb", <<-MIGRATION
      class CreateTheTable2 < ActiveRecord::Migration[#{rails_version}]
        def change
          create_table "the_table2", :force => true do |t|
            t.date "date"
            t.integer "max_online", :default => 0
          end
          add_index "the_table2", ["date"], :name => "index_statistics_on_date_and"
        end
      end
    MIGRATION
  end

  private

  def assert_migration(path, expect)
    actual = File.read(migrations_path.join path)

    assert_string actual, expect
  end

  def schema_file
    File.expand_path("../fixtures/schema.rb", __FILE__)
  end

  def migrations_path
    Pathname.new File.expand_path("../target", __FILE__)
  end
end
