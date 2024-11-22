class ChangeDefaultQuantityInCartProducts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :cart_products, :quantity, from: 1, to: 0
  end
end
