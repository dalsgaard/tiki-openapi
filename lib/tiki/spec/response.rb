require_relative './props'
require_relative './content'

using Props

# TODO: headers and links

class Response
  include Content
  props :description
  scalar_props :description
  hash_props :content

  def initialize(type = nil, mime = nil, description: nil, desc: nil, example: nil)
    @description = description || desc
    if mime || type
      @default_content = content mime, example: example do
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
    props
  end

  alias desc description
end
