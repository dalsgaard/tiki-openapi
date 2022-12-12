SPEC_FILES = %w[
  components.rb
  content.rb
  external-documentation.rb
  info.rb
  list-helpers.rb
  media-type.rb
  operation.rb
  parameter.rb
  path-item.rb
  props.rb
  reason.rb
  reference.rb
  request-body.rb
  response.rb
  schema.rb
  security.rb
  server.rb
  spec.rb
].map { |fn| "lib/tiki/spec/#{fn}" }

SERVE_FILES = %w[
  create-app.rb
  create-operation.rb
].map { |fn| "lib/tiki/serve/#{fn}" }

SOM_FILES = %w[
  som.rb
].map { |fn| "lib/tiki/som/#{fn}" }

CLIENT_FILES = %w[
  client.rb
].map { |fn| "lib/tiki/client/#{fn}" }

Gem::Specification.new do |s|
  s.name        = 'tiki'
  s.version     = '0.0.1'
  s.summary     = 'Tiki'
  s.description = 'A tool for creating and using OpenAPI specs'
  s.authors     = ['Kim Dalsgaard']
  s.email       = 'kim@kimdalsgaard.com'
  s.files       =  SPEC_FILES +
                   SERVE_FILES +
                   SOM_FILES +
                   ['Gemfile', 'bin/tiki', 'lib/tiki.rb', 'lib/tiki-spec.rb', 'lib/tiki-serve.rb', 'lib/tiki/client.rb']
  s.homepage =
    'https://rubygems.org/gems/tiki'
  s.license = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.required_ruby_version = '>= 2.6.0'
  s.add_runtime_dependency 'addressable'
  s.add_runtime_dependency 'excon'
  s.add_runtime_dependency 'hanami-router'
  s.add_runtime_dependency 'optimist'
  s.add_runtime_dependency 'puma'
  s.executables << 'tiki'
end
