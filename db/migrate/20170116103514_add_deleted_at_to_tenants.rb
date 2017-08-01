class AddDeletedAtToTenants < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :deleted_at, :datetime
    add_index :tenants, :deleted_at
  end
end
