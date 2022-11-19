openapi do
  info 'My Spec', '1.0.0'

  components do
    object :Foo do
      nullable
      string :foo?, length: 3..10
      number :bar?, range: 0...100
    end
    object :Bas do
      string :foo do
        read_only
      end
    end
    array :Bass, ref: :Bas
    any :AnyValue
  end
end
