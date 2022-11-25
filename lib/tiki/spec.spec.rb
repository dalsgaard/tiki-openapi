require_relative './spec'

describe do
  describe 'openapi' do
    describe 'an minimum openapi' do
      let(:spec) { Spec.new }

      it 'should return a correct spec' do
        spec.openapi { info 'An OpenAPI', '1.0.0' }
        expect(spec.to_spec).to eq(
          {
            openapi: '3.0.3',
            info: {
              title: 'An OpenAPI',
              version: '1.0.0'
            },
            paths: {}
          }
        )
      end
    end
  end

  describe 'Info Object' do
    let(:info) { Info.new }

    describe 'a minimum Info object' do
      before do
        info.version '1.0.0'
        info.title 'An OpenAPI'
      end

      it 'should return a correct spec' do
        expect(info.to_spec).to eq(
          {
            title: 'An OpenAPI',
            version: '1.0.0'
          }
        )
      end
    end
  end

  describe 'Contact Object' do
    describe 'a minimum object' do
      let(:contact) { Contact.new }

      it 'should return a correct spec' do
        expect(contact.to_spec).to eq({})
      end
    end

    describe 'a fully initialized object' do
      let(:contact) do
        Contact.new 'Foo Bar', url: 'foo.bar', email: 'foo@bar'
      end

      it 'should return a correct spec' do
        expect(contact.to_spec).to eq(
          { name: 'Foo Bar', url: 'foo.bar', email: 'foo@bar' }
        )
      end
    end
  end
end
