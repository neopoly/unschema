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
      preset_version

      calls_for_tables = collect_calls(intermediator.calls)
      log "Found #{calls_for_tables.size} tables"

      calls_for_tables.sort.each do |table_name, calls|
        log "  Dumping #{table_name.inspect}"
        dump_table_calls table_name, calls
      end

      log "Done"
    end

    private

    def log(string)
      puts string if verbose?
    end

    def preset_version
      @version = intermediator.version
    end

    def intermediator
      ActiveRecord::Schema.intermediator
    end

    def collect_calls(calls)
      calls_for_tables = Hash.new { |hash, key| hash[key] = [] }

      calls.each do |call|
        table_name = call.first_arg
        calls_for_tables[table_name] << call
      end

      calls_for_tables
    end

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
