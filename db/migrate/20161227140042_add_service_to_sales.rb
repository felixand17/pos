class AddServiceToSales < ActiveRecord::Migration[5.0]
  def change
    add_column :sales, :service, :boolean, default: :true
  end
end
