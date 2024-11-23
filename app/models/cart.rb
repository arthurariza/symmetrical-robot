class Cart < ApplicationRecord
  INACTIVE_HOURS_TO_ABANDON = 3
  INACTIVE_DAYS_TO_REMOVE = 7

  has_many :cart_products
  has_many :products, through: :cart_products
  belongs_to :user

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  def total_price=(value)
    super(BigDecimal(value))
  rescue ArgumentError, TypeError
    nil
  end

  def update_total_price!
    self.total_price = self.cart_products.sum(&:total_price)
    save!
  end

  def abandoned?
    abandoned
  end

  def update_last_interaction
    update(last_interaction_at: DateTime.now)
  end

  def toggle_abandoned
    abandoned = INACTIVE_HOURS_TO_ABANDON.hours.ago > last_interaction_at

    update(abandoned: abandoned)
  end
end
