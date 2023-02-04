openapi do
  info 'Example Demo', '1.0.0'
  path '/pets/{id}' do
    get :get_pets_by_id do
      response [:Pet], example: [{ name: 'Laicey' }, { name: 'Arne' }]
    end
  end
  components do
    object :Pet do
      property :name, :string
    end
  end
end
