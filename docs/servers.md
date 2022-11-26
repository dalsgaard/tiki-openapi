# Servers

## Single Server

```ruby
openapi do
  ...
  server 'https://development.gigantic-server.com/v1', 'Development server'
end
```

```json
{
  ...
  "servers": [
    {
      "url": "https://development.gigantic-server.com/v1",
      "description": "Development server"
    }
  ]
}
```

## Multiple Servers

```ruby
openapi do
  ...
  server 'https://development.gigantic-server.com/v1', 'Development server'
  server 'https://staging.gigantic-server.com/v1' do
    description 'Staging server'
  end
  server do
    url 'https://api.gigantic-server.com/v1'
    description 'Production server'
  end
end
```

```json
{
  ...
  "servers": [
    {
      "url": "https://development.gigantic-server.com/v1",
      "description": "Development server"
    },
    {
      "url": "https://staging.gigantic-server.com/v1",
      "description": "Staging server"
    },
    {
      "url": "https://api.gigantic-server.com/v1",
      "description": "Production server"
    }
  ]
}
```

### Alternative Syntax

```ruby
openapi do
  ...
  servers 'https://development.gigantic-server.com/v1',
          'https://staging.gigantic-server.com/v1': 'Staging server',
          'https://api.gigantic-server.com/v1': 'Production server'
end
```

## Server Variables

```ruby
openapi do
  ...
  server 'https://{username}.gigantic-server.com:{port}/{basePath}' do
    description 'The production API server'
    variable :username, 'demo'
    variable :port do
      enum [8443, 443]
      default 8443
    end
    variable :basePath, 'v2'
  end
end
```

```json
{
  ...
  "servers": [
    {
      "url": "https://{username}.gigantic-server.com:{port}/{basePath}",
      "description": "The production API server",
      "variables": {
        "username": {
          "default": "demo"
        },
        "port": {
          "default": "8443",
          "enum": [
            "8443",
            "443"
          ]
        },
        "basePath": {
          "default": "v2"
        }
      }
    }
  ]
}
```

### Alternative Syntax

```ruby
openapi do
  ...
  server 'https://{username}.gigantic-server.com:{port}/{basePath}' do
    description 'The production API server'
    variables username: 'demo', port: [8443, 443], basePath: 'v2'
  end
end
```

First element in array is use as default
