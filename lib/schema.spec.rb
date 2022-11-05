require_relative './schema.rb'

describe do
  describe 'a string schema' do
    let(:schema) { Schema.new :string }
    it 'should return a spec with type object' do
      expect(schema.to_spec).to eq({ type: :string })
    end
  end

  describe 'a string schema with max_length' do
    let(:schema) { Schema.new :string, max_length: 80 }
    it 'should return a spec with type object' do
      expect(schema.to_spec).to eq({ type: :string, maxLength: 80 })
    end
  end

  describe 'an array schema with string items' do
    let(:schema) { Schema.new :array }
    it 'should return a spec with string items' do
      schema.items :string
      expect(schema.to_spec).to eq({ type: :array, items: { type: :string } })
    end
  end

  describe 'an object schema with a string property' do
    let(:schema) { Schema.new :object }
    it 'should return a spec with a property' do
      schema.property :foo, :string
      expect(schema.to_spec).to eq({ type: :object, properties: { foo: { type: :string } } })
    end
  end
end
