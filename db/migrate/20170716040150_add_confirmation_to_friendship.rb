class AddConfirmationToFriendship < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :confirmation_needed, :boolean, default: false
    add_column :friendships, :confirmed, :boolean, default: false
  end
end
