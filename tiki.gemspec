Gem::Specification.new do |s|
  s.name        = 'tiki'
  s.version     = '0.0.1'
  s.summary     = 'Tiki'
  s.description = 'A tool for creating and using OpenAPI specs'
  s.authors     = ['Kim Dalsgaard']
  s.email       = 'kim@kimdalsgaard.com'
  s.files       = %w[
    components.rb
    media-type.rb
    props.rb
    response.rb
    server.rb
    content.rb
    operation.rb
    reason.rb
    response.spec.rb
    server.spec.rb
    external-documentation.rb
    parameter.rb
    reference.rb
    schema.rb
    spec.rb
    info.rb
    security.rb
    list-helpers.rb
    path-item.rb
    request-body.rb
    schema.spec.rb
    spec.spec.rb
  ].map { |fn| "lib/tiki/#{fn}" } + ['Gemfile', 'bin/tiki', 'lib/tiki.rb']
  s.homepage =
    'https://rubygems.org/gems/tiki'
  s.license = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.required_ruby_version = '>= 2.6.0'
  s.add_runtime_dependency 'optimist'
  s.executables << 'tiki'
end
