class AddPictureToPostAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :post_attachments, :picture, :string
  end
end
