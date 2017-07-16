class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.integer :user_id, index: true
      t.integer :friend_id, index: true

      t.timestamps
    end
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
