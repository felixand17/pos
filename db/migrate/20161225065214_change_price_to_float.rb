class ChangePriceToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :order_details, :price, :float
  end
end
