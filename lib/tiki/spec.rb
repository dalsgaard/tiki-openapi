require 'json'
require_relative './props'
require_relative './path-item'
require_relative './components'
require_relative './server'
require_relative './info'

using Props

class Spec
  include ServerMethods

  object_props :info, :components
  hash_props :paths
  array_props :servers

  def initialize
    @paths = []
  end

  def version(spec_version)
    @spec_version = spec_version
  end

  def openapi(spec_version = '3.0.3', &block)
    @spec_version = spec_version
    instance_eval(&block)
  end

  def info(title = nil, version = nil, &block)
    @info = Info.new title, version
    @info.instance_eval(&block) if block
  end

  def path(url, summary = nil, **named, &block)
    root = PathItemRoot.new @paths
    parent = root.child url
    path = PathItem.new parent, summary, **named
    path.instance_eval(&block) if block
    parent.add path
  end

  def components(&block)
    return unless block

    @components ||= Components.new
    @components.instance_eval(&block)
  end

  def to_spec
    @paths.each do |(url, path_item)|
      path_item.check_parameters url
    end
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
