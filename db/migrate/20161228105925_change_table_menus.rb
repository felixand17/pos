class ChangeTableMenus < ActiveRecord::Migration[5.0]
  def change
    remove_column :menus, :code
    add_column  :menus, :availability, :boolean, default: true
  end
end
