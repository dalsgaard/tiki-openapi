require_relative './props'

using Props

class License
  props :name, :url
  scalar_props :name, :url

  def initialize(name = nil, _url = nil, url: nil)
    @name = name
    @url = url || _url
  end

  def to_spec
    scalar_props
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
  props :title, :version, %i[description desc], %i[terms_of_service terms]
  scalar_props :title, :version, :description, :terms_of_service
  object_props :license, :contact

  def initialize(title = nil, version = nil, license: nil)
    @title = title
    @version = version
    @license = License.new license if license
  end

  def license(*args, **named, &block)
    @license = License.new(*args, **named)
    @license.instance_eval(&block) if block
  end

  def contact(name = nil, **named, &block)
    @contact = Contact.new name, **named
    @contact.instance_eval(&block) if block
  end

  def to_spec
    props = {}
    scalar_props props
    object_props props
  end
end
