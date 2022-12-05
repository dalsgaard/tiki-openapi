openapi do
  info 'External Documentation Demo', '1.0.0'
  path '/hello' do
    get :hello do
      response :string
      external_docs do
        description 'Find more info here'
        url 'https://example.com'
      end
    end
  end
end
