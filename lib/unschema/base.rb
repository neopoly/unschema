require 'active_record'

module Unschema
  class Base < Struct.new(:schema_file, :migrations_path, :start_version)
    def self.process!(*args)
      new(*args).process
    end

    def process
      disarm_schema_loader!

      load schema_file

      calls_for_tables = Hash.new{|hash, key| hash[key] = []}

      ActiveRecord::Schema.intermediator.calls.each do |call|
        table_name = call.args.first.to_s if [:create_table, :add_index].include?(call.name)
        raise "Don't now how to process #{call.name.inspect}" unless table_name

        calls_for_tables[table_name] << call
      end

      calls_for_tables.sort.each do |table_name, calls|
        dump_table_calls table_name, calls
      end
    end

    private
    def disarm_schema_loader!
      ActiveRecord::Schema.class_eval do
        class << self
          attr_accessor :intermediator
        end

        def self.define(*args, &block)
          self.intermediator ||= Unschema::SchemaIntermediator.new
          self.intermediator.process(*args, &block)
        end
      end
    end

    def dump_table_calls(table_name, calls)
      File.open(File.join(migrations_path, "#{next_migration}_create_#{table_name}.rb"), "w") do |f|
        f << "content"
      end
    end

    def next_migration
      @next_migration ||= start_version

      @next_migration += 1
    end

  end
end
