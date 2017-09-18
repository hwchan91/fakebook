class AddLikedUsersIdToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :liked_users_id, :text, array: true, default: []
  end
end
