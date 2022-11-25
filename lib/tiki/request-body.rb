require_relative './props'
require_relative './content'

using Props

class RequestBody
  include Content
  props :description, :required
  scalar_props :description
  hash_props :content

  def initialize(type = nil, mime = nil, description: nil, required: false)
    @description = description
    @required = required
    content mime do
      schema(type) if type
    end
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props[:required] = @required if @required
    props
  end
end
