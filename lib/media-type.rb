require_relative './props'

using Props

class MediaType
  def initialize(schema = :object)
    @schema = Schema.new schema if schema
  end

  def schema(schema = :object, &block)
    @schema = Schema.new schema
    @schema.instance_eval(&block) if block
  end

  def to_spec
    props = {}
    props[:schema] = @schema.to_spec if @schema
    props
  end
end
