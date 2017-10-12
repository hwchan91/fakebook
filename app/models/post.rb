class Post < ApplicationRecord
  include ApplicationHelper

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :liked_user_relationships, class_name:  "Like",
                                     dependent:   :destroy
  has_many :liked_users, through: :liked_user_relationships, source: :user

  has_many :post_attachments, dependent:   :destroy
  accepts_nested_attributes_for :post_attachments

  #default_scope -> { order(created_at: :desc) }
  validates :user, presence: true
  #validates :content, allow_blank: true
  validate :text_or_photos


  after_create :add_post_to_newest_list
  #before_validation(on: :update) { cache_updated_at }
  #before_update :remove_post_from_redis
  #after_update :add_post_to_newest_list
  after_destroy :remove_post_from_newest_list

  def liked_by?(user)
    !liked_user_relationships.find_by(user_id: user.id).nil?
  end

  def liked_friends(user)
    liked_users.all.select{ |liked_user| user.friend?(liked_user) } #don't know why but need to add #all to liked_user to return ALl liked_users, else would be truncated
  end

  def liked_names
    liked_users.pluck(:username) 
  end

  def text_or_photos
    if content.strip.empty? and post_attachments.blank?
      errors.add(:content, "cannot be blank unless photos are added")
    end
  end

  # def add_post_to_redis
  #   add_record_to_redis(self)
  # end

  # def cache_updated_at #this is necessary because it is executed after update, causing the score, i.e. updated_at to be changed
  #   @updated_at = self.updated_at.to_i.to_s
  # end

  # def remove_post_from_redis_before_update
  #   remove_record_from_redis(self, @updated_at)
  # end

  # def remove_post_from_redis
  #   remove_record_from_redis(self)
  # end

  def add_post_to_newest_list
    $redis.lpush("newest_post_ids", id)
    $redis.ltrim("newest_post_ids", 0, 99)
    RedisWorker.perform_async(id)
  end

  def remove_post_from_newest_list
    $redis.lrem("newest_post_ids", -1, id)
    $redis.zremrangebyscore("newest_posts", id, id)
  end


end
