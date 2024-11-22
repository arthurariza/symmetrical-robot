require 'rails_helper'

RSpec.describe "/carts", type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"
  describe "POST /add_items" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      xit 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe 'GET /cart' do
    let(:user) { create(:user) }
    let(:jwt) { JWT.encode({ user_id: user.id }, ENV.fetch("JWT_SECRET")) }
    let(:cart) { create(:cart, user: user) }

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
