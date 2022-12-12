openapi do
  info 'Serve Demo', '1.0.0'

  server 'http://localhost:8080', 'devel'

  path '/bars/{id}' do
    get :get_bar do
      parameter :q
      response :string
    end
  end
end
