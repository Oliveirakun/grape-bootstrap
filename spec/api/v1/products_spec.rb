require 'spec_helper'

describe APIv1::Products do
  include Rack::Test::Methods

  def app
    APIv1::Products
  end

  describe 'GET /api/v1/products' do
    let(:product1) { FactoryGirl.create(:product, name: 'Test 1') }
    let(:product2) { FactoryGirl.create(:product, name: 'Test 2') }
    let(:expected_response) { Product.all.to_json }

    it 'returns all products' do
      get '/api/v1/products'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'GET /api/v1/products/:id' do
    let(:product) { FactoryGirl.create(:product, name: 'Foo') }
    let(:expected_response) { product.to_json }
    let(:expected_response_for_not_found) do
      { error: 'Product not found' }.to_json
    end

    it 'returns requested product' do
      get "/api/v1/products/#{product.id}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(expected_response)
    end

    it 'returns error when product is not found' do
      get '/api/v1/products/1000'

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq(expected_response_for_not_found)
    end
  end

  describe 'GET /api/v1/products/name/:name' do
    let(:product) { FactoryGirl.create(:product, name: 'Foo') }
    let(:expected_response) { product.to_json }
    let(:expected_response_for_not_found) do
      { error: 'Product not found' }.to_json
    end

    it 'returns requested product' do
      get "/api/v1/products/name/#{product.name}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(expected_response)
    end

    it 'returns error when product is not found' do
      get '/api/v1/products/name/bar'

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq(expected_response_for_not_found)
    end
  end

  describe 'GET /api/v1/products/sku/:sku' do
    let(:product) { FactoryGirl.create(:product, sku: 'ABC123') }
    let(:expected_response) { product.to_json }
    let(:expected_response_for_not_found) do
      { error: 'Product not found' }.to_json
    end

    it 'returns requested product' do
      get "/api/v1/products/sku/#{product.sku}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(expected_response)
    end

    it 'returns error when product is not found' do
      get "/api/v1/products/sku/BBB345"

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq(expected_response_for_not_found)
    end
  end

  describe 'POST /api/v1/products' do
    let(:body) do
      {
        name:  'boom',
        color: 'black',
        sku:   'ABC123'
      }
    end

    context 'when there is no validation errors' do
      it 'save product' do
        post '/api/v1/products', body, { 'Content-Type' => 'application/json' }

        expect(last_response.status).to eq(201)
      end
    end

    context 'when has validation errors' do
      let(:expected_response) do
        { error: 'Validation failed: Name has already been taken' }.to_json
      end

      before do
        FactoryGirl.create(:product, name: 'boom')
      end

      it 'returns error' do
        post '/api/v1/products', body, { 'Content-Type' => 'application/json' }

        expect(last_response.status).to eq(409)
        expect(last_response.body).to eq(expected_response)
      end
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let(:product) { FactoryGirl.create(:product) }
    let(:body) do
      {
        name:  'boom',
        color: 'black',
        sku:   'ABC123'
      }
    end

    it 'save product' do
      put "/api/v1/products/#{product.id}", body, { 'Content-Type' => 'application/json' }

      expect(last_response.status).to eq(204)
      expect(Product.first.name).to eq(body[:name])
      expect(Product.first.color).to eq(body[:color])
      expect(Product.first.sku).to eq(body[:sku])
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let(:product) { FactoryGirl.create(:product) }

    it 'delete product' do
      delete "/api/v1/products/#{product.id}"

      expect(last_response.status).to eq(204)
      expect(Product.count).to eq(0)
    end
  end
end

