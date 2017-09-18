class RemoveLikedUsersIdFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :liked_users_id, :text
  end
end
