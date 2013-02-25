require 'helper'
require 'fileutils'
require 'pathname'

class EndToEndTest < TestCase

  def test_schema_to_migrations
    schema_file = File.expand_path("../fixtures/schema.rb", __FILE__)
    migrations_path = Pathname.new File.expand_path("../target", __FILE__)

    Dir[migrations_path.join "*.rb"].map { |file| File.delete(file) }

    Unschema::Base.process!(schema_file, migrations_path.to_s, 1000)

    assert_equal ["1001_create_abc.rb", "1002_create_table1.rb", "1003_create_table2.rb"], Dir[migrations_path.join "*.rb"].map{|path| File.basename(path)}.sort
  end

end
