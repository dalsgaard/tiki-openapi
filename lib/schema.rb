require_relative './props'

using Props

class Schema
  props :title, :description, :ref, :max_length, :format
  named_props :max_length, :min_length, :format, :unique_items
  scalar_props :type, :max_length, :min_length, :title, :description, :unique_items
  object_props :items
  hash_props :properties

  def initialize(type = nil, title = nil, **named)
    if type.is_a? String
      @ref = type
    else
      named_props named
      @type = type
      @title = title
    end
  end

  def unique_items
    @unique_items = true
  end

  def items(type = nil, title = nil, &block)
    @items = Schema.new type, title
    instance_eval(&block) if block
  end

  def enum(*items)
    @enum = items.flatten
  end

  def property(name, type = :string, _title = nil, **named, &block)
    @properties ||= []
    schema = Schema.new type, **named
    schema.instance_eval(&block) if block
    @properties.push [name, schema]
  end

  def to_spec
    if @ref
      { "$ref": @ref }
    else
      props = {}
      scalar_props props
      object_props props
      hash_props props
      props
    end
  end
end
