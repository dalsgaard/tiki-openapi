require_relative "./props"
require_relative "./path-item"
require_relative "./components"
require_relative "./server"
require_relative "./info"

using Props

class Spec
  include ServerMethods

  props %i[spec_version version]
  object_props :info, :components
  hash_props :paths
  array_props :servers

  def initialize
    @paths = []
  end

  def openapi(
    _title = nil,
    _version = nil,
    title: nil,
    version: nil,
    spec_version: "3.0.3",
    &block
  )
    @spec_version = spec_version
    info _title, _version, title: title, version: version if title || _title
    instance_eval(&block) if block
  end

  def info(*args, **named, &block)
    @info = Info.new(*args, **named)
    @info.instance_eval(&block) if block
  end

  def path(url, *args, **named, &block)
    root = PathItemRoot.new @paths
    parent = root.child url
    path = PathItem.new parent, *args, **named
    path.instance_eval(&block) if block
    parent.add path
  end

  def components(&block)
    @components ||= Components.new
    @components.instance_eval(&block) if block
  end

  %i[schema object array hash_map response parameter].each do |method|
    define_method method do |*args, **named, &block|
      components { send(method, *args, **named, &block) }
    end
  end

  def to_spec
    @paths.each { |(url, path_item)| path_item.check_parameters url }
    props = { openapi: @spec_version }
    object_props props
    hash_props props
    array_props props
    props
  end
end

class PathItemRoot
  attr_reader :paths

  def initialize(paths)
    @paths = paths
  end

  def child(url)
    PathItemParent.new url, self, []
  end

  def parameters
    []
  end
end

class PathItemParent
  attr_reader :url

  def initialize(url, parent, parameters)
    @url = url
    @parent = parent
    @parameters = parameters
  end

  def child(url, parameters)
    PathItemParent.new @url + url, self, parameters
  end

  def add(path_item)
    @parent.paths.push [@url, path_item]
  end

  def paths
    @parent.paths
  end

  def parameters
    @parent.parameters + @parameters
  end
end
