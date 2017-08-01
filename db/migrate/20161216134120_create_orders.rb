class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string  :code
      t.string  :customer
      t.references  :user
      t.timestamps
    end
  end
end
