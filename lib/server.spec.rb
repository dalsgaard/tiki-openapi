require_relative './server'

describe do
  describe 'Server Object' do
    describe 'an minimum Server' do
      let(:server) { Server.new 'foo.bar/baz' }

      it 'should return a correct spec' do
        expect(server.to_spec).to eq(
          {
            url: 'foo.bar/baz'
          }
        )
      end
    end

    describe 'a Server with variables' do
      let(:server) { Server.new 'foo.bar/baz' }
      before do
        server.variable :foo, 'Foo'
        server.variable :bar, 'Bar'
      end

      it 'should return a correct spec' do
        expect(server.to_spec).to eq(
          {
            url: 'foo.bar/baz',
            variables: {
              foo: { default: 'Foo' },
              bar: { default: 'Bar' }
            }
          }
        )
      end
    end
  end

  describe 'Server Variable Object' do
    let(:variable) { ServerVariable.new 'bar' }

    describe 'a minimum Server Variable object' do
      it 'should return a correct spec' do
        expect(variable.to_spec).to eq(
          {
            default: 'bar'
          }
        )
      end
    end
  end
end
