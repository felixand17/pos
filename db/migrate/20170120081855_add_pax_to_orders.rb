class AddPaxToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :pax, :integer
  end
end
