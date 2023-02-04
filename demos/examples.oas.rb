openapi do
  info 'Examples Demo', '1.0.0'
  path '/pets/{id}' do
    get :get_pets_by_id do
      response do
        schema [:Pet]
        example :dogs, [{ name: 'Laicey' }, { name: 'Arne' }], summary: 'Dogs'
        example :cats, [{ name: 'Phoenix' }, { name: 'Fellini' }], summary: 'Cats'
      end
    end
  end
  path '/pets' do
    post :create_pet do
      body :Pet
      response 201
    end
  end
  components do
    object :Pet do
      property :name, :string
    end
  end
end
