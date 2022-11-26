require_relative './props'
require_relative './schema'

using Props

INS = %i[query header cookie].freeze

class Parameter
  props :description

  def initialize(name, in: :query, required: false, schema: :string)
    @name = name
    @in = binding.local_variable_get(:in)
    @required = required || @in == :path
    @schema = Schema.new schema if schema
  end

  def required(required = true)
    @required = required || @in == :path
  end

  def schema(type, &block)
    @schema = Schema.new type
    @schema.instance_eval(&block) if block
  end

  def path
    @in = :path
    @required = true
  end

  def in(_in)
    @in = _in
  end

  INS.each do |_in|
    define_method _in do
      @in = _in
    end
  end

  def to_spec
    props = { name: @name, in: @in, schema: @schema.to_spec }
    props[:required] = true if @required
    props[:description] = @description if @description
    props
  end

  def get_name
    @name.to_s
  end
end
