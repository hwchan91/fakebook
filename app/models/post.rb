class Post < ApplicationRecord
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

  def liked_by?(user)
    !liked_user_relationships.find_by(user_id: user.id).nil?
  end

  def liked_friends(user)
    liked_users.all.select{ |liked_user| user.friend?(liked_user) } #don't know why but need to add #all to liked_user to return ALl liked_users, else would be truncated
  end

  def like_sentence(user)
    arr = []
    first_friend = liked_friends(user)[0]
    second_friend = liked_friends(user)[1]

    arr << "You" if liked_by?(user)
    arr << first_friend.username if !first_friend.nil?
    arr << second_friend.username if !second_friend.nil?

    others_count = liked_users.count - arr.count
    arr << others_count.to_s + " " + "other".pluralize(others_count) if others_count > 0
    if arr.count > 1
      sentence = arr.first(arr.size - 1).join(", ") + " and " + arr[-1]
    else
      sentence = arr[0].to_s
    end
  end

  def text_or_photos
    if content.strip.empty? and post_attachments.blank?
      errors.add(:content, "cannot be blank unless photos are added")
    end
  end

end
