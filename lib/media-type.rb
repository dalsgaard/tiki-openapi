require_relative './props'
require_relative './reference'
require_relative './schema'

using Props

class MediaType
  props :ref

  def initialize(schema: :object, ref: nil)
    if ref
      @schema = Reference.new ref
    elsif schema
      @schema = Schema.new schema
    end
  end

  def schema(schema = :object, ref: nil, &block)
    if ref
      @schema = Reference.new ref
    else
      @schema = Schema.new schema
      @schema.instance_eval(&block) if block
    end
  end

  def to_spec
    props = {}
    props[:schema] = @schema.to_spec if @schema
    props
  end
end
