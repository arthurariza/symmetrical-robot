require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
  end

  describe '#total_price' do
    it 'calculates the total price based on quantity and unit price' do
      cart_product = CartProduct.new(quantity: 2, unit_price: '1.99')
      expect(cart_product.total_price).to eq(3.98)
    end
  end

  describe '#unit_price=' do
    it 'converts the unit_price to a BigDecimal' do
      cart_product = CartProduct.new
      cart_product.unit_price = '19.99'
      expect(cart_product.unit_price).to eq(BigDecimal('19.99'))
    end

    it 'handles invalid values gracefully' do
      cart_product = CartProduct.new
      cart_product.unit_price = 'abcd'
      expect(cart_product.unit_price).to be_nil
    end
  end
end
