require_relative './props'

using Props

class ExternalDocumentation
  props :url, :description
  scalar_props :url, :description

  def initialize(_url = nil, _desc = nil, url: nil, desc: nil, description: nil)
    @description = description || desc || _desc
    @url = url || _url
  end

  def to_spec
    scalar_props
  end
end
