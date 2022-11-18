require_relative './props'
require_relative './reference'

using Props

PRIMITIVES = %i[string integer number boolean].freeze

FORMATS = [
  [:integer, %i[int32 int64]],
  [:number, %i[float double]],
  [:string, %i[byte binary date date_time datetime password], { date_time: 'date-time', datetime: 'date-time' }]

].freeze

class Schema
  props :title, :description, :ref, :max_length, :format
  named_props :max_length, :min_length, :format, :unique_items
  scalar_props :type, :max_length, :min_length, :title, :description, :unique_items, :format
  object_props :items, :all_of, :one_of, :any_of
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

  def items(type = nil, title = nil, ref: nil, &block)
    if ref
      @items = Reference.new ref
    else
      @items = Schema.new type, title
      instance_eval(&block) if block
    end
  end

  def enum(*items)
    @enum = items.flatten
  end

  def property(name, type = :string, _title = nil, optional: false, ref: nil, **named, &block)
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

  def object(name, title = nil, **named, &block)
    property name, :object, title, **named, &block
  end

  def object?(name, title = nil, **named, &block)
    object name, title, optional: true, **named, &block
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

  def to_spec
    if @ref
      { '$ref': @ref }
    else
      props = {}
      scalar_props props
      object_props props
      hash_props props
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
  def initialize(*refs)
    @schemas = refs.flatten.map { |ref| Reference.new(ref) }
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
