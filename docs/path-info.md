# Path Info

```ruby
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
```

```json
{
  "/pets/{id}": {
    "get": {
      "operationId": "get_pets_by_id",
      "responses": {
        "200": {
          "description": "OK",
          "content": {
            "*/*": {
              "schema": {
                "type": "array",
                "items": {
                  "$ref": "#/components/schemas/Pet"
                }
              }
            }
          }
        },
        "default": {
          "description": "error payload",
          "content": {
            "text/html": {
              "schema": {
                "$ref": "#/components/schemas/ErrorModel"
              }
            }
          }
        }
      }
    },
    "parameters": [
      {
        "name": "id",
        "in": "path",
        "required": true,
        "style": "simple",
        "schema": {
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      }
    ]
  }
}
```
