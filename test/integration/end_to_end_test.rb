require 'helper'
require 'fileutils'
require 'pathname'

class EndToEndTest < TestCase

  def test_schema_to_migrations
    schema_file = File.expand_path("../fixtures/schema.rb", __FILE__)
    migrations_path = Pathname.new File.expand_path("../target", __FILE__)

    Dir[migrations_path.join "*.rb"].map { |file| File.delete(file) }

    Unschema::Base.process!(schema_file, migrations_path.to_s, 1000)

    assert_equal ["1001_create_abc.rb", "1002_create_table1.rb", "1003_create_the_table2.rb"], Dir[migrations_path.join "*.rb"].map{|path| File.basename(path)}.sort

    migration = File.read(File.join(migrations_path, "1001_create_abc.rb"))
    expectation = <<-MIGRATION
    class CreateAbc < ActiveRecord::Migration
      def change
        create_table "abc" do |t|
          t.string "defgh"
        end
      end
    end
    MIGRATION

    assert_equal expectation.chomp.gsub(/^\s*/,""), migration.gsub(/^\s*/,"")

    migration = File.read(File.join(migrations_path, "1002_create_table1.rb"))
    expectation = <<-MIGRATION
    class CreateTable1 < ActiveRecord::Migration
      def change
        create_table "table1", {:force=>true} do |t|
          t.string "str"
          t.integer "int"
          t.datetime "created_at"
          t.datetime "updated_at"
        end
        add_index "table1", ["id"], {:name=>"the_index_1", :unique=>true}
        add_index "table1", ["doesnt_make_sende"], {:name=>"the_index_2", :unique=>true, :wrong_attr=>1}
      end
    end
    MIGRATION

    assert_equal expectation.chomp.gsub(/^\s*/,""), migration.gsub(/^\s*/,"")

    migration = File.read(File.join(migrations_path, "1003_create_the_table2.rb"))
    expectation = <<-MIGRATION
    class CreateTheTable2 < ActiveRecord::Migration
      def change
        create_table "the_table2", {:force=>true} do |t|
          t.date "date"
          t.integer "max_online", {:default=>0}
        end
        add_index "the_table2", ["date"], {:name=>"index_statistics_on_date_and"}
      end
    end
    MIGRATION

    assert_equal expectation.chomp.gsub(/^\s*/,""), migration.gsub(/^\s*/,"")
  end

end
