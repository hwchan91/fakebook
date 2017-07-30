class PostAttachment < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :post

  validate :picture_size

  after_destroy do |att|
    post = att.post
    if post.post_attachments.empty?
      post.destroy unless post.nil?
    end
  end

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end
