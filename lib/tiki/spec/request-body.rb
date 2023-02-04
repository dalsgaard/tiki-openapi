require_relative './props'
require_relative './content'

using Props

class RequestBody
  include Content
  props :description, :required
  named_props :mime, :description, :required
  scalar_props :description
  hash_props :content

  def initialize(type = nil, _mime = nil, **named)
    @mime = _mime
    named_props named
    if @mime || type
      @default_content = content @mime do
        schema(type) if type
      end
    end
  end

  def example(*args, **named)
    @default_content ||= content
    @default_content.example(*args, **named)
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props[:required] = @required if @required
    props
  end
end
