openapi do
  info 'Servers Demo', '1.0.0'

  server 'https://{username}.gigantic-server.com:{port}/{basePath}' do
    description 'The production API server'
    variable :username, 'demo'
    variable :port do
      enum [8443, 443]
      default 8443
    end
    variable :basePath, 'v2'
  end
end
