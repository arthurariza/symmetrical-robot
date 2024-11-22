class Cart < ApplicationRecord
  has_many :cart_products
  has_many :products, through: :cart_products
  belongs_to :user

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  def total_price=(value)
    super(BigDecimal(value))
  rescue ArgumentError, TypeError
    nil
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
end
