GROUPS = {
  schema: 'components/schemas',
  response: 'components/responses',
  request_body: 'components/requestBody'
}.freeze

class Reference
  attr_reader :ref

  def initialize(ref, group = :schema)
    @ref = create_reference ref, group
  end

  def to_spec
    { :$ref => @ref }
  end
end

def create_reference(ref, group = :schema)
  ref.is_a?(Symbol) ? "#/#{GROUPS[group]}/#{ref}" : ref
end
