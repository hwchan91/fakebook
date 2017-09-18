class Post < ApplicationRecord
  include ApplicationHelper

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :liked_user_relationships, class_name:  "Like",
                                     dependent:   :destroy
  has_many :liked_users, through: :liked_user_relationships, source: :user

  has_many :post_attachments, dependent:   :destroy
  accepts_nested_attributes_for :post_attachments

  default_scope -> { order(updated_at: :desc) }
  validates :user, presence: true
  #validates :content, allow_blank: true
  validate :text_or_photos


  after_create :add_post_to_redis
  before_validation(on: :update) { cache_updated_at }
  before_update :remove_post_from_redis_before_update
  after_update :add_post_to_redis
  after_destroy :remove_post_from_redis


  def liked_by?(user)
    !liked_user_relationships.find_by(user_id: user.id).nil?
  end

  def liked_friends(user)
    liked_users.all.select{ |liked_user| user.friend?(liked_user) } #don't know why but need to add #all to liked_user to return ALl liked_users, else would be truncated
  end

 # def like_sentence(user, post, friend_ids = nil, liked_ids = nil, liked_names = nil)
 #   friend_ids ||= user.friend_ids
 #   liked_ids ||= post.liked_users.pluck(:id)
 #   common_ids= friend_ids & liked_ids 
 #   common_ids_index = common_ids.map{|id| liked_ids.rindex(id)}

 #   liked_names ||= post.liked_users.pluck(:username)
 #   common_names = liked_names

 #   arr = []
 #   first_friend_name = liked_names[common_ids_index[0]]
 #   second_friend_name =liked_names[common_ids_index[1]]

 #   arr << "You" if liked_ids.include?(user.id)
 #   arr << first_friend_name if first_friend_name
 #   arr << second_friend_name if second_friend_name

 #   others_count = liked_ids.count - arr.count
 #   arr << others_count.to_s + " " + "other".pluralize(others_count) if others_count > 0
 #   if arr.count > 1
 #     sentence = arr.first(arr.size - 1).join(", ") + " and " + arr[-1]
 #   else
 #     sentence = arr[0].to_s
 #   end
 # end

  def text_or_photos
    if content.strip.empty? and post_attachments.blank?
      errors.add(:content, "cannot be blank unless photos are added")
    end
  end

  def add_post_to_redis
    add_record_to_redis(self)
  end

  def cache_updated_at
    @updated_at = self.updated_at.to_i.to_s
  end

  def remove_post_from_redis_before_update
    remove_record_from_redis(self, @updated_at)
  end

  def remove_post_from_redis
    remove_record_from_redis(self)
  end

  def liked_users_count(friend_ids, current_user_id)
    common_ids= friend_ids & post.liked_user_ids 
    common_ids_index = common_ids.map{|id| post.liked_user_ids.rindex(id)}
    names ||= post.liked_users.pluck(:username)
  
    arr = [] 
    arr << "You" if post.liked_user_ids.include?(current_user_id)
    arr << names[common_ids_index[0]] if common_ids_index[0]
    arr << names[common_ids_index[1]] if common_ids_index[1]
  
    others_count = post.liked_user_ids.count - arr.count
    arr << others_count.to_s + " " + "other".pluralize(others_count) if others_count > 0
    (arr.count > 1) ? (arr.first(arr.size - 1).join(", ") + " and " + arr[-1]) : arr[0].to_s
  end




end
