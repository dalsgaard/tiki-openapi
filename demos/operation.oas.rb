openapi do
  info 'Operation Demo', '1.0.0'

  path '/pets/{pet_id}' do
    put :update_pet_with_form do
      tags :pet
      summary 'Updates a pet in the store with form data'
      parameter! :pet_id, in: :path, schema: :string, desc: 'ID of pet that needs to be updated'
      body do
        content :form do
          schema do
            property :name?, :string, desc: 'Updated name of the pet'
            property :status, :string, desc: 'Updated status of the pet'
          end
        end
      end
      response desc: 'Pet updated.' do
        content :json, :all
        content :xml, :all
      end
      response 405 do
        content :json, :all
        content :xml, :all
      end
      security petstore_auth: ['write:pets', 'read:pets']
    end
  end
end
