openapi do
  info 'My Spec', '1.0.0'

  path '/orders' do
    get 'get_orders' do
      response { ref [:Order] }
      responses 400, 500
    end

    path '/{id}' do
      get :get_order do
        response { ref :Order }
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
      ref :address, :Address
    end

    schema :Address
  end
end
