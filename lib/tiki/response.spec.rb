require_relative './response'

describe do
  let(:response) { Response.new 'My Response' }

  describe 'a minimal response' do
    it 'should return a correct spec' do
      expect(response.to_spec).to eq({ description: 'My Response' })
    end
  end

  describe 'content' do
    describe 'default mime type' do
      before do
        response.content
      end

      it 'should return a correct spec' do
        expect(response.to_spec).to eq(
          {
            description: 'My Response',
            content: {
              'application/json' => {
                schema: { type: :object }
              }
            }
          }
        )
      end
    end
  end

  describe 'a schema' do
    describe 'a schema type' do
      before do
        response.schema :object
      end

      it 'should return a correct spec' do
        expect(response.to_spec).to eq(
          {
            description: 'My Response',
            content: {
              'application/json' => {
                schema: {
                  type: :object
                }
              }
            }
          }
        )
      end
    end

    describe 'a ref' do
      before do
        response.schema ref: :Address
      end

      it 'should return a correct spec' do
        expect(response.to_spec).to eq(
          {
            description: 'My Response',
            content: {
              'application/json' => {
                schema: {
                  :$ref => '#/components/schemas/Address'
                }
              }
            }
          }
        )
      end
    end
  end

  describe 'an array' do
    describe 'a items schema type' do
      before do
        response.array :string
      end

      it 'should return a correct spec' do
        expect(response.to_spec).to eq(
          {
            description: 'My Response',
            content: {
              'application/json' => {
                schema: {
                  type: :array,
                  items: { type: :string }
                }
              }
            }
          }
        )
      end

      describe 'a items ref' do
        before do
          response.array ref: :Address
        end

        it 'should return a correct spec' do
          expect(response.to_spec).to eq(
            {
              description: 'My Response',
              content: {
                'application/json' => {
                  schema: {
                    type: :array,
                    items: { :$ref => '#/components/schemas/Address' }
                  }
                }
              }
            }
          )
        end
      end
    end
  end

  describe 'an object' do
    before do
      response.object
    end

    it 'should return a correct spec' do
      expect(response.to_spec).to eq(
        {
          description: 'My Response',
          content: {
            'application/json' => {
              schema: { type: :object }
            }
          }
        }
      )
    end
  end

  describe 'a ref' do
    before do
      response.ref :Address
    end

    it 'should return a correct spec' do
      expect(response.to_spec).to eq(
        {
          description: 'My Response',
          content: {
            'application/json' => {
              schema: { :$ref => '#/components/schemas/Address' }
            }
          }
        }
      )
    end
  end
end
