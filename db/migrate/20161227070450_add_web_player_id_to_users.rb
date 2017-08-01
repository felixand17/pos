class AddWebPlayerIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :web_player_id, :string
  end
end
