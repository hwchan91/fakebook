class CreateFriendRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_requests do |t|
      t.integer :requestor_id, index: true
      t.integer :receiver_id, index: true
      t.boolean :confirmed,  default: false

      t.timestamps
    end
    add_index :friend_requests, [:requestor_id, :receiver_id], unique: true
  end
end
