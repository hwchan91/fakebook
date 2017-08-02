class PostAttachment < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :post
  has_attached_file :picture, :styles => {
      :thumb => "100x100#",
      :small  => "300x300#",
      :medium => "400x400#" }
  validates_attachment :picture, presence: true, size: { in: 0..5.megabytes }, content_type: { content_type: /\Aimage/ }


#  after_destroy do |att|
#    post = att.post
#    if post.post_attachments.empty?
#      post.destroy unless !post.content.nil?
#    end
#  end


end
