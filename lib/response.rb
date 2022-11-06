require_relative './props'
require_relative './media-type'

using Props

class Response
  props :description
  scalar_props :description
  hash_props :content

  def initialize(description = nil, _schema = nil)
    @description = description
  end

  def content(mime = 'application/json', schema: nil, &block)
    @content ||= []
    media_type = MediaType.new schema
    media_type.instance_eval(&block) if block
    @content.push [mime, media_type]
    media_type
  end

  def schema(_schema = nil, &block)
    content do
      schema _schema, &block
    end
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props
  end
end
