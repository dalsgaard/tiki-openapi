require_relative './props'

using Props

class ServerVariable
  props :default, :enum, :description
  named_props :enum
  scalar_props :default, :enum, :description

  def initialize(default = nil, **named)
    @default = default
    named_props named
  end

  def to_spec
    scalar_props
  end
end

class Server
  props :url, :description
  scalar_props :url, :description
  hash_props :variables

  def initialize(url = nil)
    @url = url
  end

  def variable(name, default = nil, **named)
    @variables ||= []
    variable = ServerVariable.new default, **named
    @variables.push [name, variable]
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props
  end
end
