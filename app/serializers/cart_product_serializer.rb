class CartProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :unit_price, :total_price

  def name
    object.product.name
  end

  def unit_price
    object.unit_price.to_f
  end

  def total_price
    object.total_price.to_f
  end
end
