openapi do
  info 'Servers Demo 2', '1.0.0'

  server 'https://{username}.gigantic-server.com:{port}/{basePath}' do
    description 'The production API server'
    variables username: 'demo', port: [8443, 443], basePath: 'v2'
  end
end
