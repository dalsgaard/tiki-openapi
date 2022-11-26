openapi do
  info 'Servers Demo', '1.0.0'

  servers 'https://development.gigantic-server.com/v1',
          'https://staging.gigantic-server.com/v1': 'Staging server',
          'https://api.gigantic-server.com/v1': 'Production server'
end
