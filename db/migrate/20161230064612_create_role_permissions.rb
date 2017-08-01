class CreateRolePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :role_permissions, id: false do |t|
      t.belongs_to :role
      t.belongs_to :permission
      t.timestamps
    end
  end
end
