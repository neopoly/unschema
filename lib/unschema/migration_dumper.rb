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
      f << "end\n"
    end

    private

    def dump_call(call)
      str = "    #{call.name} #{stringify_call call}"

      if call.block
        receiver = call.block.name
        str << " do |#{receiver}|\n"

        call.block.calls.each do |block_call|
          str << "      #{receiver}.#{block_call.name} #{stringify_call block_call}\n"
        end

        str << "    end"
      end

      str << "\n"
      str
    end

    def table_name_camelcased
      @table_name.gsub(/^(\w)/){|s| s.upcase }.gsub(/(_\w)/) { |s| s[-1, 1].upcase }
    end

    def stringify_call(call)
      args    = stringify_args(call.args)
      options = stringify_options(call.options) unless call.options.empty?
      [ args, options ].compact.join(", ")
    end

    def stringify_args(args)
      args[0] = args[0].to_sym
      args.inspect.gsub(/^\[|\]$/,"")
    end

    def stringify_options(options)
      options.map { |key, value| "#{key.inspect} => #{value.inspect}" }.join(", ")
    end
  end
end
