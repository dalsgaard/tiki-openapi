openapi do
  path '/orders' do
    get 'get_orders' do
      response do
        array ref: :Order
      end
    end
  end
  components do
    schema :Order
  end
end
