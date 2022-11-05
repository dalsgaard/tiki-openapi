openapi '3.0.1' do
  info do
    title 'Demo Spec'
    version '1.0.1'
    license 'MIT'
  end
  path '/onboarding-data/{id}' do
    put 'putOnboardingData' do
      parameter 'id', in: :path, required: true, schema: :string
      body do
        required
        content 'application/json', '#/components/schemas/OnboardingData'
      end
      response 204
      responses 400, 404
    end
  end
  path '/AccountSet' do
    get do
      summary 'Read Accounts'
      tags 'AccountSet'
      parameter 'filter', in: :query, schema: :string do
        description 'Filter items by property values, see [Filtering](https://help.sap.com/doc/5890d27be418427993fafa6722cdc03b/Cloud/en-US/OdataV2.pdf#page=64)'
      end
      parameter ref: '#/components/parameters/count'
      parameter 'orderby' do
        path
        schema :array do
          unique_items
          items :string do
            enum %w[ID ID_desc AccountHolderID AccountHolderID_desc]
          end
        end
      end

      response 200, 'Retrieved Accounts' do
        schema :object do
          title 'Wrapper'
          property :d, :object do
            title 'Collection of Accounts'
            property :results, :array do
              items '#/components/schemas/bacovr.Account'
            end
          end
        end
      end
    end
  end
  components do
    schema 'bacovr.Account', :object do
      property :ID, :string, max_length: 80, min_length: 8 do
        title 'Bank Account ID (IBAN if available, otherwise unique string)'
      end
    end
    schema 'bacovr.Balance', :object
  end
end
