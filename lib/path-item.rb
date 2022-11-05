require_relative './props'
require_relative './operation'

using Props

VERBS = %i[get put post].freeze

class PathItem
  props :ref, :summary, :description
  scalar_props :summary, :description
  hash_props :operations

  def initialize(summary = nil, ref: nil)
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

  def to_spec
    if @ref
      { :$ref => @ref }
    else
      props = {}
      scalar_props props
      hash_props props
      props
    end
  end
end
