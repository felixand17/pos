class AddPriceToOrderDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :order_details, :price, :decimal, precision: 7, scale: 2
  end
end
