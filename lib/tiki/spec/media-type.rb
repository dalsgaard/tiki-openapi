require_relative './props'
require_relative './reference'
require_relative './schema'
require_relative './example'

using Props

class MediaType
  props :ref
  object_props :schema
  scalar_props :example
  hash_props :examples

  def initialize(_schema = nil, schema: nil, ref: nil, example: nil)
    if ref
      @schema = Reference.new ref
    elsif schema
      @schema = Schema.new schema || _schema || :object
    end
    @example = example
  end

  def schema(type = :object, title = nil, ref: nil, &block)
    if ref
      @schema = Reference.new ref
    else
      @schema = Schema.new type, title
      @schema.instance_eval(&block) if block
    end
  end

  def example(name, value = nil, **named)
    if value
      @examples ||= []
      example = Example.new(value, **named)
      @examples << [name.to_s, example]
    else
      @example = name
    end
  end

  def to_spec
    props = {}
    object_props props
    scalar_props props
    hash_props props
    props
  end
end
