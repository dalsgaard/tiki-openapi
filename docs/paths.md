# Paths

```ruby
openapi do
  ...
  path '/pets' do
    get :get_pets do
      desc 'Returns all pets from the system that the user has access to'
      response [:Pet] do
        desc 'A list of pets.'
      end
    end
  end
end
```

```json
{
  ...
  "paths": {
    "/pets": {
      "get": {
        "operationId": "get_pets",
        "description": "Returns all pets from the system that the user has access to",
        "responses": {
          "200": {
            "description": "A list of pets.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Pet"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```
