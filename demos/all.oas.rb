openapi 'Demo Spec' do
  path '/orders' do
    get :get_orders, [:Order], example: [{ name: 'Nike' }]
  end
  object :Order do
    property :name, :string
  end
end
