GROUPS = {
  schema: 'components/schemas',
  response: 'components/responses'
}.freeze

class Reference
  attr_reader :ref

  def initialize(ref, group = :schema)
    @ref = ref.is_a?(Symbol) ? "#/#{GROUPS[group]}/#{ref}" : ref
  end

  def to_spec
    { :$ref => @ref }
  end
end
