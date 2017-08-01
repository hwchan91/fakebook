class AddAttachmentPictureToPostAttachments < ActiveRecord::Migration[5.1]
  def self.up
    change_table :post_attachments do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :post_attachments, :picture
  end
end
