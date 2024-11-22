require 'rails_helper'

RSpec.describe Cart::DestroyProductService do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: '10.0') }
  let(:cart) { create(:cart, user: user) }
  let(:service) { described_class.new(user, product.id) }

  describe '#call' do
    context 'when the product is in the cart' do
      before do
        create(:cart_product, cart: cart, product: product, quantity: 1, unit_price: '10.0')
      end

      it 'destroys the product in the cart' do
        expect { service.call }.to change { cart.cart_products.count }.by(-1)
      end

      it 'updates the cart total_price' do
        service.call
        expect(cart.reload.total_price).to eq(0)
      end

      it 'returns the cart' do
        result = service.call
        expect(result).to eq(cart)
      end
    end

    context 'when the product is not in the cart' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordNotFound, "Product was not found in cart")
      end
    end

    context 'when no products are in the cart' do
      it 'returns the cart with total_price as 0' do
        create(:cart_product, cart: cart, product: product, quantity: 1, unit_price: '10.0')

        result = service.call
        expect(result).to eq(cart)
        expect(cart.reload.total_price).to eq(0)
        expect(cart.cart_products.count).to eq(0)
      end
    end
  end
end
