class AddTaxToSales < ActiveRecord::Migration[5.0]
  def change
    add_column :sales, :tax, :boolean, default: :true
  end
end
