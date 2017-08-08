class RemovePictureFromPostAttachment < ActiveRecord::Migration[5.1]
  def change
    remove_column :post_attachments, :picture, :string
  end
end
