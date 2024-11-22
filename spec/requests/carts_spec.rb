require 'rails_helper'

RSpec.describe "/cart", type: :request do
  let(:user) { create(:user) }
  let(:jwt) { JWT.encode({ user_id: user.id }, ENV.fetch("JWT_SECRET")) }
  let(:cart) { create(:cart, user: user) }

  describe 'POST /cart' do
    let(:product_id) { '1' }
    let(:quantity) { '2' }

    before do
      allow(Cart::ManageProductService).to receive(:call).with(user, product_id, quantity).and_return(cart)
    end

    it 'calls the Cart::ManageProductService with the correct parameters' do
      post cart_url, params: { product_id: product_id, quantity: quantity }, headers: { "Authorization" => "Bearer #{jwt}" }

      expect(Cart::ManageProductService).to have_received(:call).with(user, product_id, quantity)
    end

    it 'renders the serialized cart' do
      post cart_url, params: { product_id: product_id, quantity: quantity }, headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.keys).to eq([ 'id', 'total_price', 'products' ])
    end

    it 'returns a 401 if the user is not authenticated' do
      post cart_url

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a 422 if validations fail' do
      allow(Cart::ManageProductService).to receive(:call).and_raise(ActiveRecord::RecordInvalid)

      post cart_url, params: { product_id: product_id, quantity: quantity }, headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body).to eq({ "error" => "Record invalid" })
    end

    it 'returns a 404 if the product is not found' do
      allow(Cart::ManageProductService).to receive(:call).and_raise(ActiveRecord::RecordNotFound, "Product not found")

      post cart_url, params: { product_id: product_id, quantity: quantity }, headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(:not_found)
      expect(response.parsed_body).to eq({ "error" => "Product not found" })
    end
  end

  describe 'GET /cart' do
    before do
      allow(Cart::FindService).to receive(:call).with(user).and_return(cart)
    end

    it 'calls the Cart::FindService with the current user' do
      get cart_url, headers: { "Authorization" => "Bearer #{jwt}" }

      expect(Cart::FindService).to have_received(:call).with(user)
    end

    it 'renders the serialized cart' do
      get cart_url, headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.keys).to eq([ 'id', 'total_price', 'products' ])
    end

    it 'returns a 401 if the user is not authenticated' do
      get cart_url

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
