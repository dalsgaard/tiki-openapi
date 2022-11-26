openapi do
  info 'Spec', '1.0.0'

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
      any :bar
    end
    array :Bass, ref: :Bas
    schema :Color, enum: [:red, :green, :blue, nil]
    hash_map :Hash, ref: :Color
  end
end
