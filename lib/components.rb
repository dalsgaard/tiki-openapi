require_relative './props'
require_relative './schema'
require_relative './reference'
require_relative './parameter'

using Props

class Components
  hash_props :schemas, :parameters

  def schema(name, type = :object, title = nil, &block)
    @schemas ||= []
    schema = Schema.new type, title
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

  def to_spec
    hash_props
  end
end
