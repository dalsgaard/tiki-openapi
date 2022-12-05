require_relative './props'
require_relative './schema'

using Props

PARAMETER_INS = %i[query path header cookie].freeze
PARAMETER_STYLES = %i[simple form matrix label space_delimited pipe_delimited deep_object].freeze

# TODO: content, example, examples

class Parameter
  props :name, %i[description desc], :in, :style
  marker_props :required, :deprecated, :allow_empty_value, :explode
  named_props %i[description desc], :in, :required, :deprecated, %i[allow_empty_value allow_empty], :style, :explode
  scalar_props :name, :in, :description, :required, :deprecated, :allow_empty_value, :style, :explode
  object_props :schema

  def initialize(name, schema: :string, **named)
    @name = name
    @schema = Schema.new schema if schema
    named_props named
  end

  def schema(*args, **named, &block)
    @schema = Schema.new(*args, **named)
    @schema.instance_eval(&block) if block
  end

  PARAMETER_INS.each do |_in|
    define_method _in do
      @in = _in
    end
  end

  PARAMETER_STYLES.each do |style|
    define_method style do
      @style = style
    end
  end

  def to_spec
    @in ||= :query
    @required = true if @in == :path
    props = {}
    scalar_props props
    object_props props
    props
  end

  def get_name
    @name.to_s
  end
end
