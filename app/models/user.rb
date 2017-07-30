class User < ApplicationRecord
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
  has_attached_file :avatar

  validates_attachment :avatar, presence: true, size: { in: 0..5.megabytes }, content_type: { content_type: /\Aimage/ }

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
    Post.where("user_id IN (?) OR user_id = ?", friend_ids, id )
  end

#  def confirmed_friends
#    friendships.where(confirmed: true)
#  end

#  def confirmed_friend?(other_user)
#    !confirmed_friends.find_by(friend_id: other_user.id).nil?
#  end

#  def pending
#    friendships.where(confirmation_needed: false, confirmed: false)
#  end

#  def pending?(other_user)
#    !pending.find_by(friend_id: other_user.id).nil?
#  end

#  def request
#    friendships.where(confirmation_needed: true, confirmed: false)
#  end

#  def request?(other_user)
#    !request.find_by(friend_id: other_user.id).nil?
#  end

#  def confirm(other_user)
#    friendships.find_by(friend_id: other_user.id).update_attributes(confirmed: true)
#  end

#  def undo_confirm(other_user)
#    friendships.find_by(friend_id: other_user.id).update_attributes(confirmed: false)
#  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.delete(post)
  end

#  def pictures
#    pics = []
#    posts_with_pics = posts.select{ |p| !p.post_attachments.nil? }
#    posts_with_pics.each do |p|
#      pics += p.post_attachments
#    end
#    pics
#  end

end
