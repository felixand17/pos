class ChangeTableSales < ActiveRecord::Migration[5.0]
  def change
    remove_column :sales, :tax, :boolean
    remove_column :sales, :service, :boolean
    add_column :sales, :tax, :float, default: '0.0'
    add_column :sales, :service, :float, default: '0.0'
  end
end
