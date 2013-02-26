require 'active_record'

module Unschema
  class Base < Struct.new(:schema_file, :migrations_path, :start_version, :verbose)
    def self.process!(*args)
      new(*args).process
    end

    def verbose?
      !!verbose
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

      puts "Found #{calls_for_tables.keys.size} tables" if verbose?

      calls_for_tables.sort.each do |table_name, calls|
        puts "  Dumping #{table_name.inspect}" if verbose?
        dump_table_calls table_name, calls
      end
      puts "Done" if verbose?
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
        f << "class Create#{table_name.gsub(/^(\w)/){|s| s.upcase }.gsub(/(_\w)/){|s| s[-1, 1].upcase} } < ActiveRecord::Migration\n"
        
        f << "  def change\n"

        calls.each do |call|
          str = "    #{call.name} #{stringify_args call.args}"

          if call.block
            receiver = call.block.name
            str += " do |#{receiver}|\n"

            call.block.calls.each do |block_call|
              str += "      #{receiver}.#{block_call.name} #{stringify_args block_call.args}\n"
            end

            str += "    end\n"
          else
            str += "\n"
          end


          f << str
        end

        f << "  end\nend"
      end
    end

    def stringify_args(args)
      args.inspect.gsub(/^\[|\]$/,"")
    end

    def next_migration
      @next_migration ||= start_version

      @next_migration += 1
    end

  end
end
