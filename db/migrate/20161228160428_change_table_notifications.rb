class ChangeTableNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column  :notifications, :entity_id, :integer
    add_column  :notifications, :entity_type, :string
    add_index :notifications, [:entity_type, :entity_id]
  end
end
