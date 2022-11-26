openapi do
  info 'Paths Demo', '1.0.0'
  path '/pets' do
    get :get_pets do
      desc 'Returns all pets from the system that the user has access to'
      response [:Pet] do
        desc 'A list of pets.'
      end
    end
  end
  components do
    object :Pet
  end
end
