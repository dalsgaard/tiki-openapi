openapi do
  info 'Path Item Demo', '1.0.0'
  path '/pets/{id}' do
    get :get_pets_by_id do
      response [:Pet], mime: :all
      response :default, :ErrorModel, mime: :html, desc: 'error payload'
    end
    parameter! :id, in: :path, schema: [:string] do
      desc 'ID of pet to use'
      simple
    end
  end
  components do
    object :Pet
    object :ErrorModel
  end
end
