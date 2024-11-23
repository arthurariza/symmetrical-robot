class AddAbandonedLastInteractionIndexToCarts < ActiveRecord::Migration[7.1]
  def change
    add_index :carts, [ :abandoned, :last_interaction_at ]
  end
end
