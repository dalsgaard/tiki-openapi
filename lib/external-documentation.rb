require_relative './props'

using Props

class ExternalDocumentation
  props :url, :description
  scalar_props :url, :description

  def initialize(url = nil)
    @url = url
  end

  def to_spec
    scalar_props
  end
end
