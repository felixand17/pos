class AddBuffetToOrderDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :order_details, :buffet, :boolean, default: false
  end
end
