class User < ApplicationRecord
  include ApplicationHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true, uniqueness: true

  has_many :active_requests, class_name:  "FriendRequest",
                             foreign_key: "requestor_id",
                             dependent:   :destroy
  has_many :passive_requests, class_name:  "FriendRequest",
                              foreign_key: "receiver_id",
                              dependent:   :destroy
  has_many :sent_requests, through: :active_requests, source: :receiver
  has_many :received_requests, through: :passive_requests, source: :requestor
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :like_post_relationships, class_name:  "Like",
                                    dependent:   :destroy
  has_many :liked_posts, through: :like_post_relationships, source: :post
  has_many :post_attachments, through: :posts
  has_attached_file :avatar, :default_url => "assets/images/:style/default_avatar.jpg", :styles => {
      :comment_thumb => "40x40#",
      :thumb => "60x60#",
      :small  => "300x300#",
      :medium => "400x400#" }
  validates_attachment :avatar, allow_nil: true, size: { in: 0..5.megabytes }, content_type: { content_type: /\Aimage/ }

  devise :omniauthable, :omniauth_providers => [:facebook]

  # after_update :update_redis

  def friend_request(other_user)
    sent_requests << other_user
  end

  def undo_friend_request(other_user)
    sent_requests.delete(other_user)
  end

  def pending_request?(other_user)
    if active = active_requests.find_by(receiver_id: other_user.id)
      !active.confirmed
    else
      false
    end
  end

  def awaiting_confirm?(other_user)
    if passive = passive_requests.find_by(requestor_id: other_user.id)
      !passive.confirmed
    else
      false
    end
  end

  def confirm_request(other_user)
    passive_requests.find_by(requestor_id: other_user.id).update_attributes(confirmed: true)
    friendships.create!(friend_id: other_user.id)
  end

  def undo_confirm_request(other_user)
    friendships.find_by(friend_id: other_user.id).destroy
    passive_requests.find_by(requestor_id: other_user.id).update_attributes(confirmed: false)
  end

  def deny_request(other_user)
    passive_requests.find_by(requestor_id: other_user.id).destroy
  end

  def unfriend(other_user)
    friendships.find_by(friend_id: other_user.id).destroy
    if active = active_requests.find_by(receiver_id: other_user.id)
      active.destroy
    elsif passive = passive_requests.find_by(requestor_id: other_user.id)
      passive.destroy
    end
  end

  def friend?(other_user)
    !friendships.find_by(friend_id: other_user.id).nil?
  end

  def unrelated?(other_user)
    requests = self.received_requests + self.sent_requests
    !requests.include?(other_user) and self != other_user
  end


#shortcut method to skip confirmation
  def friend(other_user)
    friendships.create!(friend_id: other_user.id)
  end

  def feed
    Post.includes(:user, :liked_users, :post_attachments).where("(user_id IN (?) OR user_id = ?)", friend_ids, id ).order(created_at: :desc)
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.destroy(post)
  end


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name   # assuming the user model has a name
      user.fb_avatar = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def avatar_present?
    avatar.present?
  end

  def avatar_url_thumb
    avatar.url(:thumb)
  end

  # def update_redis
  #   last_post = $redis.zrevrange("newest_posts", -1 ,-1)[0]
  #   last_id = $redis.zscore("newest_posts", last_post)
  #   self.posts.where("id >= #{last_id}").each do |post|
  #     remove_record_from_redis(post)
  #     add_record_to_redis(post)
  #   end
  # end

end
