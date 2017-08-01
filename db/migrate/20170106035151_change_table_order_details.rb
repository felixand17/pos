class ChangeTableOrderDetails < ActiveRecord::Migration[5.0]
  def change
    add_column  :order_details, :tenant_id, :integer
    add_column  :order_details, :menu_name, :string
    add_index   :order_details, :tenant_id
  end
end
