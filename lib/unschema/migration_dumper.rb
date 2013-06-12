module Unschema
  class MigrationDumper
    def initialize(table_name, calls)
      @table_name = table_name
      @calls      = calls
    end

    def dump_to(f)
      f << "class Create#{table_name_camelcased} < ActiveRecord::Migration\n"
      f << "  def change\n"

      @calls.each do |call|
        f << dump_call(call)
      end

      f << "  end\n"
      f << "end"
    end

    private

    def dump_call(call)
      str = "    #{call.name} #{stringify_args call.args}"

      if call.block
        receiver = call.block.name
        str << " do |#{receiver}|\n"

        call.block.calls.each do |block_call|
          str << "      #{receiver}.#{block_call.name} #{stringify_args block_call.args}\n"
        end

        str << "    end"
      end

      str << "\n"
      str
    end

    def table_name_camelcased
      @table_name.gsub(/^(\w)/){|s| s.upcase }.gsub(/(_\w)/) { |s| s[-1, 1].upcase }
    end

    def stringify_args(args)
      args.inspect.gsub(/^\[|\]$/,"")
    end
  end
end
