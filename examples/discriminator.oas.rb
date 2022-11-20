openapi do
  info 'Discriminator Demo', '1.0.0'

  components do
    object :Pet do
      one_of :Dog, :Cat, :Hamster
      discriminator :pet_type, dog: :Dog, cat: :Cat, hamster: :Hamster
    end
    object :Dog do
      string :pet_type
    end
    object :Cat do
      string :pet_type
    end
    object :Hamster do
      string :pet_type
    end
  end
end
