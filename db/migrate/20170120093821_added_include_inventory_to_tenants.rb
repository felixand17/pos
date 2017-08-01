class AddedIncludeInventoryToTenants < ActiveRecord::Migration[5.0]
  def change
    add_column  :tenants, :include_inventory, :boolean, default: false
  end
end
