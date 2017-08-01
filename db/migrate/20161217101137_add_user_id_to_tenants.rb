class AddUserIdToTenants < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :user_id, :integer
    add_index  :tenants, :user_id
  end
end
