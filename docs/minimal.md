# Minimal Example

minimal.oas.rb

```ruby
openapi do
  info 'Minimal Demo', '1.0.0'
  path '/hello' do
    get :hello do
      response :string
    end
  end
end
```

`> tiki`

minimal.oas.json

```json
{
  "openapi": "3.0.3",
  "info": {
    "title": "Minimal Demo",
    "version": "1.0.0"
  },
  "paths": {
    "/hello": {
      "get": {
        "operationId": "hello",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "type": "string"
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
