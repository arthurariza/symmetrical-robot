require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'validations' do
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
  end

  context 'associations' do
    it { should have_many(:cart_products) }
    it { should have_many(:products).through(:cart_products) }
    it { should belong_to(:user) }
  end

  describe '#total_price=' do
    it 'converts the total_price to a BigDecimal' do
      cart = Cart.new
      cart.total_price = '19.99'
      expect(cart.total_price).to eq(BigDecimal('19.99'))
    end

    it 'handles integer values correctly' do
      cart = Cart.new
      cart.total_price = '20'
      expect(cart.total_price).to eq(BigDecimal('20'))
    end

    it 'handles float values correctly' do
      cart = Cart.new
      cart.total_price = '20.50'
      expect(cart.total_price).to eq(BigDecimal('20.50'))
    end

    it 'handles invalid values gracefully' do
      cart = Cart.new
      cart.total_price = 'abcd'
      expect(cart.total_price).to be_nil
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { create(:shopping_cart) }

    xit 'marks the shopping cart as abandoned if inactive for a certain time' do
      shopping_cart.update(last_interaction_at: 3.hours.ago)
      expect { shopping_cart.mark_as_abandoned }.to change { shopping_cart.abandoned? }.from(false).to(true)
    end
  end

  describe 'remove_if_abandoned' do
    let(:shopping_cart) { create(:shopping_cart, last_interaction_at: 7.days.ago) }

    xit 'removes the shopping cart if abandoned for a certain time' do
      shopping_cart.mark_as_abandoned
      expect { shopping_cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end
  end
end
