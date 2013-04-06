# Mock ActiveRecord::Schema for schema.rb.
#
# This mock intercepts all method calls in `ActiveRecord::Schema.define`.
#
# See your schema.rb.
module ActiveRecord
  class Schema
    class << self
      attr_accessor :intermediator
    end

    def self.define(options={}, &block)
      self.intermediator ||= Unschema::SchemaIntermediator.new
      self.intermediator.process(options, &block)
    end
  end
end
