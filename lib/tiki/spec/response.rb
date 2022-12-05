require_relative './props'
require_relative './content'

using Props

# TODO: headers and links

class Response
  include Content
  props :description
  scalar_props :description
  hash_props :content

  def initialize(type = nil, mime = nil, description: nil, desc: nil)
    @description = description || desc
    content mime do
      schema(type) if type
    end
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props
  end

  alias desc description
end
