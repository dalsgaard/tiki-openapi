require_relative './props'
require_relative './operation'
require_relative './server'

using Props

VERBS = %i[get put post delete options head patch trace].freeze

class PathItem
  include ServerMethods

  props :ref, :summary, :description
  scalar_props :summary, :description
  array_props :servers

  def initialize(parent, summary = nil, ref: nil)
    @parameters = []
    @parent = parent
    @summary = summary
    @ref = ref
  end

  VERBS.each do |verb|
    define_method verb do |operation_id = nil, &block|
      @operations ||= []
      operation = Operation.new operation_id
      operation.instance_eval(&block) if block
      @operations.push [verb, operation]
    end
  end

  def parameter(name = nil, ref: nil, **named, &block)
    if ref
      reference = Reference.new ref
      @parameters.push reference
    else
      named[:in] ||= :path
      parameter = Parameter.new name, **named
      parameter.instance_eval(&block) if block
      @parameters.push parameter
    end
  end

  def path(url, summary = nil, **named, &block)
    child = @parent.child url, @parameters
    path = PathItem.new child, summary, **named
    path.instance_eval(&block) if block
    child.add path
  end

  def to_spec
    if @ref
      { :$ref => @ref }
    else
      props = @operations&.map(&->((n, s)) { { n => s.to_spec } })&.inject(&:merge) || {}
      parameters = @parent.parameters + @parameters
      props[:parameters] = parameters.map(&:to_spec) unless parameters.empty?
      scalar_props props
      array_props props
      props
    end
  end

  def check_parameters(path)
    parameters = @parent.parameters + @parameters
    params = path.scan(/\{([a-zA-Z0-9_]+)\}/).map(&:first)
    params.each do |param|
      @parameters << Parameter.new(param, in: :path) unless parameters.find { |p| p.get_name == param }
    end
  end
end
