class Like < ApplicationRecord
  include ApplicationHelper

  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true, uniqueness: { scope: :post_id }
  validates :post_id, presence: true, uniqueness: { scope: :user_id }

  after_create :update_redis
  after_destroy :update_redis

  def update_redis
    post = Post.find(post_id)
    remove_record_from_redis(post)
    add_record_to_redis(post)
  end

end