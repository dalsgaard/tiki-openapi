# Operation

```ruby
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
```

```json
{
  "put": {
    "operationId": "update_pet_with_form",
    "summary": "Updates a pet in the store with form data",
    "tags": [
      "pet"
    ],
    "security": [
      {
        "petstore_auth": [
          "write:pets",
          "read:pets"
        ]
      }
    ],
    "parameters": [
      {
        "name": "pet_id",
        "in": "path",
        "description": "ID of pet that needs to be updated",
        "required": true,
        "schema": {
          "type": "string"
        }
      }
    ],
    "responses": {
      "200": {
        "description": "Pet updated.",
        "content": {
          "application/json": {
          },
          "application/xml": {
          }
        }
      },
      "405": {
        "description": "Method Not Allowed",
        "content": {
          "application/json": {
          },
          "application/xml": {
          }
        }
      }
    },
    "requestBody": {
      "content": {
        "application/x-www-form-urlencoded": {
          "schema": {
            "type": "object",
            "properties": {
              "name": {
                "type": "string"
              },
              "status": {
                "type": "string"
              }
            },
            "required": [
              "status"
            ]
          }
        }
      }
    }
  }
}
```
