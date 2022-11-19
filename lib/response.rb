require_relative './props'
require_relative './media-type'

using Props

class Response
  props :description
  scalar_props :description
  hash_props :content

  def initialize(description = nil, schema: nil, ref: nil)
    @description = description
    if ref
      ref(ref)
    elsif schema
      schema(schema)
    end
  end

  def content(mime = 'application/json', **named, &block)
    @content ||= []
    media_type = MediaType.new(**named)
    media_type.instance_eval(&block) if block
    @content.push [mime, media_type]
    media_type
  end

  def schema(type = nil, title = nil, ref: nil, **named, &block)
    if ref
      content do
        schema ref: ref
      end
    else
      content do
        schema type, title, **named, &block
      end
    end
  end

  def object(title, **named, &block)
    schema :object, title, **named, &block
  end

  def array(items_type = nil, title = nil, ref: nil, **named, &block)
    if ref
      schema :array, title do
        items ref: ref
      end
    else
      schema :array, title do
        items items_type, **named, &block
      end
    end
  end

  def ref(ref)
    if ref.is_a? Array
      array ref: ref.first
    else
      schema ref: ref
    end
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props
  end
end
