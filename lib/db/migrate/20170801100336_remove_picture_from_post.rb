class RemovePictureFromPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :picture, :string
  end
end
