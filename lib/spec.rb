require 'json'
require_relative './props'
require_relative './path-item'

using Props

class License
  props :name, :url

  def initialize(name = nil, url = nil)
    @name = name
    @url = url
  end

  def to_spec
    props = { name: @name }
    props[:url] = @url if @url
    props
  end
end

class Contact
  props :name, :url, :email
  named_props :url, :email
  scalar_props :name, :url, :email

  def initialize(name = nil, **named)
    @name = name
    named_props named
  end

  def to_spec
    scalar_props
  end
end

class Info
  props :title, :version, :description, :terms_of_service
  scalar_props :title, :version, :description, :terms_of_service
  object_props :license

  def initialize(title = nil, version = nil, license: nil)
    @title = title
    @version = version
    @license = License.new license if license
  end

  def license(name = nil, url = nil, &block)
    @license = License.new name, url
    @license.instance_eval(&block) if block
  end

  def to_spec
    props = {}
    scalar_props props
    object_props props
  end
end

class Components
  def initialize
    @schemas = []
  end

  def schema(name, type = :object, title = nil, &block)
    schema = Schema.new type, title
    schema.instance_eval(&block) if block
    @schemas.push [name, schema]
  end

  def to_spec
    props = {}
    schemas = @schemas.map(&->((n, s)) { Hash[n, s.to_spec] }).inject(&:merge)
    props[:schemas] = schemas if schemas
    props
  end
end

class Spec
  scalar_props :spec_version
  object_props :info
  hash_props :paths

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
    path = PathItem.new summary, **named
    path.instance_eval(&block) if block
    @paths.push [url, path]
  end

  def components(&block)
    return unless block

    @components ||= Components.new
    @components.instance_eval(&block)
  end

  def to_spec
    props = {}
    scalar_props props
    object_props props
    hash_props props
    props
  end
end
