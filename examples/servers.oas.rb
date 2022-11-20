openapi do
  info 'Servers Demo', '1.0.0'

  server 'https://development.gigantic-server.com/v1', 'Development server'
  server 'https://staging.gigantic-server.com/v1' do
    description 'Staging server'
  end
  server do
    url 'https://api.gigantic-server.com/v1'
    description 'Production server'
  end
end
