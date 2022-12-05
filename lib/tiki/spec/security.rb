require_relative './props'

using Props

SECURITY_INS = %i[query header cookie].freeze

class SecurityScheme
  props :type, :description, :name, :scheme, :bearer_format, :open_id_connect_url
  scalar_props :type, :description, :in, :name, :scheme, :bearer_format, :open_id_connect_url

  def initialize(type = nil, description = nil, in: nil, name: nil, scheme: nil, bearer_format: nil,
                 open_id_connect_url: nil)
    @type = type
    @description = description
    @in = binding.local_variable_get(:in)
    @name = name
    @scheme = scheme
    @bearer_format = bearer_format
    @open_id_connect_url = open_id_connect_url
  end

  def in(_in)
    @in = _in
  end

  SECURITY_INS.each do |_in|
    define_method _in do
      @in = _in
    end
  end
end

OAUTH_FLOWS = %i[implicit password client_credentials authorization_code].freeze

class OAuthFlows
  object_props(*OAUTH_FLOWS)

  OAUTH_FLOWS.each do |name|
    define_method name do |*args, **named, &block|
      flow = OAuthFlow.new(*args, **named)
      flow.instance_eval(&block) if block
      instance_variable_set "@#{name}", flow
    end
  end

  def to_spec
    object_props
  end
end

class OAuthFlow
  props :authorization_url, :token_url, :refresh_url
  scalar_props :authorization_url, :token_url, :refresh_url, :scopes

  def initialize(authorization_url = nil, token_url = nil, refresh_url = nil,
                 authorization: nil, token: nil, refresh: nil)
    @authorization_url = authorization || authorization_url
    @token_url = token || token_url
    @refresh_url = refresh || refresh_url
    @scopes = {}
  end

  def scopes(scopes = nil, **named)
    @scopes.merge! scopes if scopes
    @scopes.merge! named
  end

  def scope(name, description)
    @scopes[name] = description
  end

  def to_spec
    scalar_props
  end
end
