require_relative './props'
require_relative './schema'
require_relative './reference'
require_relative './parameter'

using Props

class Components
  hash_props :schemas, :parameters

  def schema(name, type = nil, title = nil, **named, &block)
    @schemas ||= []
    schema = Schema.new type, title, **named
    schema.instance_eval(&block) if block
    @schemas.push [name, schema]
  end

  def parameter(name = nil, ref: nil, **named, &block)
    if ref
      reference = Reference.new ref
      @parameters.push [name, reference]
    else
      @parameters ||= []
      parameter = Parameter.new name, **named
      parameter.instance_eval(&block) if block
      @parameters.push [name, parameter]
    end
  end

  def object(name, title = nil, **named, &block)
    schema name, :object, title, **named, &block
  end

  def array(name, items_type = nil, title = nil, ref: nil, **named, &block)
    if ref
      schema :array, title do
        items ref: ref
      end
    else
      schema name, :array, title do
        items items_type, **named, &block
      end
    end
  end

  def hash_map(name, items_type = nil, title = nil, ref: nil, **named, &block)
    if ref
      schema :object, title do
        additional_properties ref: ref
      end
    else
      schema name, :object, title do
        additional_properties items_type, **named, &block
      end
    end
  end

  def to_spec
    hash_props
  end
end
