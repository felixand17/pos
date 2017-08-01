class ChangeTableUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :tenants, :phone_number, :string
    add_column :tenants, :identity_number, :string
  end
end
