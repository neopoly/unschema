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

    def self.define(*args, &block)
      self.intermediator ||= Unschema::SchemaIntermediator.new
      self.intermediator.process(*args, &block)
    end
  end
end
