class AddFbavatarToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fb_avatar, :string
  end
end
