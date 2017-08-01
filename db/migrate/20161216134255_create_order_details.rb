class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
      t.references  :order
      t.references  :menu
      t.integer     :qty
      t.text        :notes
      t.string      :flag
      t.timestamps
    end
  end
end
