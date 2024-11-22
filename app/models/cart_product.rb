class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  def unit_price=(value)
    super(BigDecimal(value))
  rescue ArgumentError, TypeError
    nil
  end

  def total_price
    quantity * unit_price
  end
end
