openapi do
  info 'Minimal Demo', '1.0.0'
  path '/hello' do
    get :get_hello do
      response :string
    end
  end
end
