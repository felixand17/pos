class AddSLotToTenants < ActiveRecord::Migration[5.0]
  def change
  	add_column :tenants, :slot, :string
  end
end
