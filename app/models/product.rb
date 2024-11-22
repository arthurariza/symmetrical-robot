class Product < ApplicationRecord
  has_many :cart_products
  has_many :carts, through: :cart_products

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def price=(value)
    super(BigDecimal(value))
  rescue ArgumentError, TypeError
    nil
  end
end
