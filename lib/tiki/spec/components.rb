require_relative './props'
require_relative './schema'
require_relative './reference'
require_relative './parameter'
require_relative './security'

using Props

class Components
  hash_props :schemas, :parameters, :security_schemes

  # Schema
  def schema(name, type = nil, title = nil, **named, &block)
    if name.is_a? LessList
      name, super_class = name.list
    end
    @schemas ||= []
    schema = Schema.new type, title, **named
    schema.all_of super_class if super_class
    schema.instance_eval(&block) if block
    @schemas.push [name, schema]
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

  # Response
  def response(name = nil, _description = nil, ref: nil, **named, &block)
    if ref
      reference = Reference.new ref
      @responses << [name, reference]
    else
      @responses ||= []
      response = Response.new description, **named
      response.instance_eval(&block) if block
      @responses << [name, response]
    end
  end

  # Parameter
  def parameter(name = nil, schema = nil, ref: nil, **named, &block)
    @parameters ||= []
    if ref
      reference = Reference.new ref
      @parameters << [name, reference]
    else
      parameter = Parameter.new name, schema, **named
      parameter.instance_eval(&block) if block
      @parameters << [name, parameter]
    end
  end

  # Security Schemes
  def security_scheme(name, *args, **named, &block)
    @security_schemes ||= []
    scheme = SecurityScheme.new(*args, **named)
    scheme.instance_eval(&block) if block
    @security_schemes << [name, scheme]
  end

  def to_spec
    hash_props
  end
end
