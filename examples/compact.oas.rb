openapi do
  info 'My Spec', '1.0.0'

  path '/orders' do
    get 'get_orders' do
      response [:Order]
      responses 400, 500
    end

    path '/{id}' do
      get :get_order do
        response :Order
      end
    end
  end

  path '/foo' do
    get 'get_foo' do
      response do
        schema do
          all_of :Foo do
            schema { string :bar }
            schema { string :baz }
          end
        end
      end
    end
  end

  components do
    schema :Order do
      string :id
      string :title?
      number? :total
      int32? :foo
      date_time? :when
      refs address?: :Address, bar: :Address
    end

    schema :Address

    schema :Foo
    schema :Bar
    schema :Baz
  end
end
