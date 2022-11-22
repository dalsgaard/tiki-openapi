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
    @default = @default&.to_s
    @enum&.map!(&:to_s)
    scalar_props
  end
end

class Server
  props :url, :description
  scalar_props :url, :description
  hash_props :variables

  def initialize(url = nil, description = nil)
    @url = url
    @description = description
  end

  def variable(name, default = nil, **named, &block)
    @variables ||= []
    variable = ServerVariable.new default, **named
    variable.instance_eval(&block) if block
    @variables << [name, variable]
  end

  def variables(**vars)
    vars.each_pair do |name, value|
      if value.is_a? Array
        variable name, value.first, enum: value
      else
        variable name, value
      end
    end
  end

  def to_spec
    props = {}
    scalar_props props
    hash_props props
    props
  end
end

module ServerMethods
  def server(url = nil, description = nil, &block)
    @servers ||= []
    server = Server.new url, description
    server.instance_eval(&block) if block
    @servers << server
  end

  def servers(*singles, **pairs)
    pairs.each_pair { |url, description| server url, description }
    singles.each { |url| server url }
  end
end
