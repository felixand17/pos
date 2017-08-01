class AddDiscountToSales < ActiveRecord::Migration[5.0]
  def change
    add_column :sales, :discount, :integer
    add_column :sales, :discount_amount, :float
  end
end
