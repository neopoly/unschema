module Unschema
  class Base < Struct.new(:schema_file, :migrations_path, :verbose)
    def self.process!(*args)
      new(*args).process
    end

    def verbose?
      !!verbose
    end

    def process
      load schema_file

      @version = ActiveRecord::Schema.intermediator.version

      calls_for_tables = Hash.new{|hash, key| hash[key] = []}

      ActiveRecord::Schema.intermediator.calls.each do |call|
        table_name = call.args.first.to_s if [:create_table, :add_index].include?(call.name)
        raise "Don't now how to process #{call.name.inspect}" unless table_name

        calls_for_tables[table_name] << call
      end

      puts "Found #{calls_for_tables.keys.size} tables" if verbose?

      calls_for_tables.sort.each do |table_name, calls|
        puts "  Dumping #{table_name.inspect}" if verbose?
        dump_table_calls table_name, calls
      end
      puts "Done" if verbose?
    end

    private

    def dump_table_calls(table_name, calls)
      file = File.join(migrations_path, "#{next_migration}_create_#{table_name}.rb")
      File.open(file, "w") do |f|
        MigrationDumper.new(table_name, calls).dump_to(f)
      end
    end

    def next_migration
      @version += 1
    end
  end
end
