require 'rails_helper'

RSpec.describe Cart::ManageProductService do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: '10.0') }
  let(:service) { described_class.new(user, product.id, 2) }

  describe '#call' do
    context 'when the product exists' do
      context 'when the user has an existing cart' do
        let!(:cart) { create(:cart, user: user) }

        it 'adds the product to the cart' do
          expect { service.call }.to change { cart.cart_products.count }.by(1)
        end

        it 'updates the quantity if the product is already in the cart' do
          cart_product = create(:cart_product, cart: cart, product: product, quantity: 1, unit_price: '10.0')
          service.call
          expect(cart_product.reload.quantity).to eq(3)
        end

        it 'updates the cart total_price' do
          create(:cart_product, cart: cart, product: product, quantity: 1, unit_price: '10.0')
          service.call
          expect(cart.reload.total_price).to eq(30.0)
        end
      end

      context 'when the user does not have an existing cart' do
        it 'creates a new cart' do
          expect { service.call }.to change { Cart.count }.by(1)
        end

        it 'adds the product to the new cart' do
          cart = service.call

          expect(cart.cart_products.count).to eq(1)
          expect(cart.cart_products.first.product).to eq(product)
          expect(cart.cart_products.first.quantity).to eq(2)
        end

        it 'updates the cart total_price' do
          cart = service.call

          expect(cart.total_price).to eq(20.0)
        end
      end

      context 'when CartProduct quantity will be 0 or less' do
        let(:service) { described_class.new(user, product.id, -1) }
        let(:cart) { create(:cart, user: user) }

        it 'raises an error and does not update the quantity' do
          cart_product = create(:cart_product, cart: cart, product: product, quantity: 1, unit_price: '10.0')

          expect { service.call }.to raise_error ActiveRecord::RecordInvalid

          expect(cart.cart_products.count).to eq(1)
          expect(cart_product.reload.quantity).to eq(1)
        end
      end
    end

    context 'when the product does not exist' do
      let(:invalid_service) { described_class.new(user, -1, 2) }

      it 'raises an ActiveRecord::RecordNotFound error' do
        expect { invalid_service.call }.to raise_error(ActiveRecord::RecordNotFound, "Product not found")
      end
    end
  end
end
