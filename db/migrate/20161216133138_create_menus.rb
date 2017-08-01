class CreateMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :menus do |t|
      t.string  :code
      t.string  :name
      t.text    :description
      t.float   :price
      t.references :tenant
      t.references :category
      t.timestamps
    end
  end
end
