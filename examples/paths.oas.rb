openapi do
  info 'Paths Demo', '1.0.0'

  path '/foo', 'A summary ' do
    description 'A longer _description_'

    get :read_foo do
      response [:Foo | (:Bar & :Baz)] | :string
    end

    post :create_foo do
      response 201
      body! :Foo
    end

    put :update_foo do
      response
    end

    delete :delete_foo do
      response
    end

    server 'https://development.gigantic-server.com/v1', 'Development server'
  end

  components do
    object :Foo
    object :Bar
    object :Baz
    schema :Foos, [:Foo] | :Foo
  end
end
