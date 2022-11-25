require_relative './props'
require_relative './reference'
require_relative './list-helpers'

using Props

PRIMITIVES = %i[string integer number boolean].freeze
DATA_TYPES = PRIMITIVES + %i[object array]

FORMATS = [
  [:integer, %i[int32 int64]],
  [:number, %i[float double]],
  [:string, %i[byte binary date date_time datetime password], { date_time: 'date-time', datetime: 'date-time' }]

].freeze

NUMBER_PROPS = %i[
  minimum
  maximum
  exclusive_minimum
  exclusive_maximum
  multiple_of
].freeze

STRING_PROPS = %i[
  min_length
  max_length
  pattern
].freeze

OBJECT_PROPS = %i[
  min_properties
  max_properties
].freeze

MARKER_PROPS = %i[
  unique_items
  nullable
  read_only
  write_only
].freeze

class Schema
  props :title, :description, :format, NUMBER_PROPS, STRING_PROPS
  marker_props MARKER_PROPS
  named_props :format, MARKER_PROPS, NUMBER_PROPS, STRING_PROPS, OBJECT_PROPS
  scalar_props :type, :title, :description, :format, :enum, MARKER_PROPS, NUMBER_PROPS, STRING_PROPS, OBJECT_PROPS
  object_props :items, :all_of, :one_of, :any_of, :discriminator
  hash_props :properties
  object_or_scalar_props :additional_properties

  def initialize(type = nil, title = nil, enum: nil, additional_properties: nil, min: nil, max: nil, length: nil,
                 range: nil, **named)
    case type
    when *PRIMITIVES, :object, :array
      @type = type
    when String, Symbol
      @ref = create_reference type
    when Array
      @type = :array
      items type.first
    when OrList
      one_of(*type.list)
    when AndList
      all_of(*type.list)
    end
    additional_properties(additional_properties) if additional_properties
    enum(enum) if enum
    length(length) if length.is_a? Range
    range(range) if range.is_a? Range
    named_props named
    @title = title
    min(min) if min
    max(max) if max
  end

  def length(length)
    return unless length.is_a? Range

    @max_length = length.max
    @min_length = length.min
  end

  def range(range)
    return unless range.is_a? Range

    @maximum = range.max + (range.exclude_end? ? 1 : 0)
    @minimum = range.min
    @exclusive_maximum = range.exclude_end? || nil
  end

  def min(min)
    case @type
    when :number, :integer
      minimum min
    when :string
      min_length min
    end
  end

  def max(max)
    case @type
    when :number, :integer
      maximum max
    when :string
      max_length max
    end
  end

  def unique_items
    @unique_items = true
  end

  def nullable
    @nullable = true
  end

  def read_only
    @read_only = true
  end

  def items(type = nil, title = nil, &block)
    @items = Schema.new type, title
    instance_eval(&block) if block
  end

  def enum(*items)
    @type ||= :string
    @enum = items.flatten
    @nullable = true if @enum.include? nil
  end

  def property(name, type = :string, _title = nil, optional: false, ref: nil, **named, &block)
    @type ||= :object
    name_str = name.to_s
    if name_str.end_with? '?'
      optional = true
      name_str = name_str[0..-2]
    end
    unless optional
      @required ||= []
      @required << name_str
    end
    @properties ||= []
    if ref
      @properties << [name_str, Reference.new(ref)]
    else
      schema = Schema.new type, **named
      schema.instance_eval(&block) if block
      @properties << [name_str, schema]
    end
  end

  def additional_properties(type = nil, ref: nil, &block)
    if ref
      @additional_properties = Reference.new ref
    elsif type.is_a? Symbol
      schema = Schema.new type
      schema.instance_eval(&block) if block
      @additional_properties = schema
    else
      @additional_properties = true
    end
  end

  def object(name, title = nil, **named, &block)
    property name, :object, title, **named, &block
  end

  def object?(name, title = nil, **named, &block)
    object name, title, optional: true, **named, &block
  end

  def any(name, title = nil, **named, &block)
    property name, :any, title, **named, &block
  end

  def any?(name, title = nil, **named, &block)
    any name, title, optional: true, **named, &block
  end

  def ref(name, ref, **named)
    property name, ref: ref, **named
  end

  def ref?(name, ref, **named)
    ref(name, ref, optional: true, **named)
  end

  def refs(**named)
    named.each_pair { |name, ref| property name, ref: ref }
  end

  def all_of(*refs, &block)
    @all_of = SchemaList.new(*refs)
    @all_of.instance_eval(&block) if block
  end

  def one_of(*refs, &block)
    @one_of = SchemaList.new(*refs)
    @one_of.instance_eval(&block) if block
  end

  def any_of(*refs, &block)
    @any_of = SchemaList.new(*refs)
    @any_of.instance_eval(&block) if block
  end

  def discriminator(property_name = nil, **mapping, &block)
    @discriminator = Discriminator.new property_name, **mapping, &block
  end

  def to_spec
    if @type == :any
      {}
    elsif @ref
      { '$ref': @ref }
    else
      props = {}
      scalar_props props
      object_props props
      hash_props props
      object_or_scalar_props props
      props[:required] = @required if @required
      props
    end
  end

  def self.property_shortcuts(shortcut_name)
    define_method "#{shortcut_name}?" do |name, title = nil, **named, &block|
      send shortcut_name, name, title, optional: true, **named, &block
    end
    define_method "#{shortcut_name}s" do |*names|
      names.each { |name| send shortcut_name, name }
    end
  end

  PRIMITIVES.each do |primitive|
    define_method primitive do |name, title = nil, **named, &block|
      property name, primitive, title, **named, &block
    end
    property_shortcuts primitive
  end

  FORMATS.each do |(primitive, formats, mapping)|
    formats.each do |format|
      format_str = (mapping && mapping[format]) || format.to_s
      define_method format do |name, title = nil, **named, &block|
        send primitive, name, title, format: format_str, **named, &block
      end
      property_shortcuts format
    end
  end
end

class SchemaList
  def initialize(*types)
    @schemas = types.map { |type| Schema.new(type) }
  end

  def schema(type: :object, ref: nil, **named, &block)
    if ref
      @schemas << Reference.new(ref)
    else
      schema = Schema.new type, **named
      schema.instance_eval(&block) if block
      @schemas << schema
    end
  end

  def ref(ref)
    schema(ref: ref)
  end

  def to_spec
    @schemas.map(&:to_spec)
  end
end

class Discriminator
  props :property_name
  scalar_props :property_name

  def initialize(property_name = nil, **mapping)
    @property_name = property_name
    @mapping = mapping.transform_values { |ref| Reference.new ref }
  end

  def mapping(**mapping)
    @mapping.merge! mapping
  end

  def to_spec
    props = {}
    scalar_props props
    props[:mapping] = @mapping.transform_values(&:ref) unless @mapping.empty?
    props
  end

  alias property property_name
end
