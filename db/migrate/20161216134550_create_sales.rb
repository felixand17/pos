class CreateSales < ActiveRecord::Migration[5.0]
  def change
    create_table :sales do |t|
      t.references  :order
      t.references  :user
      t.float       :amount
      t.string      :payment_method
      t.float       :payment
      t.string      :status
      t.timestamps
    end
  end
end
