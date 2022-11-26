# Info

```ruby
info 'Sample Pet Store App', '1.0.1' do
  desc 'This is a sample server for a pet store.'
  terms 'http://example.com/terms/'
  license 'Apache 2.0', url: 'https://www.apache.org/licenses/LICENSE-2.0.html'
  contact 'API Support', url: 'http://www.example.com/support', email: 'support@example.com'
end
```

```json
"info": {
  "title": "Sample Pet Store App",
  "version": "1.0.1",
  "description": "This is a sample server for a pet store.",
  "termsOfService": "http://example.com/terms/",
  "license": {
    "name": "Apache 2.0",
    "url": "https://www.apache.org/licenses/LICENSE-2.0.html"
  },
  "contact": {
    "name": "Kim Dalsgaard Consulting",
    "url": "http://www.example.com/support",
    "email": "support@example.com"
  }
}
```
