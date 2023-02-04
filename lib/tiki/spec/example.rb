require_relative './props'

using Props

class Example
  props :summary, %i[external_value external], %i[description desc]
  named_props :summary, %i[external_value external], %i[description desc]
  scalar_props :value, :summary, :external_value, :description

  def initialize(value, **named)
    @value = value
    named_props named
  end

  def to_spec
    scalar_props
  end
end

# Media Type
# Components
# Parameter
