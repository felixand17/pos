class AddCommentToOrderDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :order_details, :comment, :string
  end
end
