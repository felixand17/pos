class AddBuffetOrderToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :buffet, :boolean, default: false
    add_column :orders, :buffet_price, :float
  end
end
