require 'rails_helper'

RSpec.describe Cart::FindService do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }

  describe '#call' do
    context 'when the user has an existing cart' do
      it 'returns the existing cart' do
        cart = create(:cart, user: user)
        expect(service.call).to eq(cart)
      end
    end

    context 'when the user does not have an existing cart' do
      it 'creates a new cart' do
        expect { service.call }.to change { Cart.count }.by(1)
      end

      it 'returns the new cart' do
        new_cart = service.call
        expect(new_cart).to be_a(Cart)
        expect(new_cart.user).to eq(user)
        expect(new_cart.total_price).to eq(0.0)
      end
    end
  end
end
