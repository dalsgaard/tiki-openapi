openapi do
  info 'Minimal Demo', '1.0.0'
  path '/hello' do
    get :hello do
      response :string
    end
  end
end
