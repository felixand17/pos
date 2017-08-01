class AddReferenceNumberToSales < ActiveRecord::Migration[5.0]
  def change
    add_column :sales, :reference_number, :string
  end
end
