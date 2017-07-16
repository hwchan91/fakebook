class Friendship < ApplicationRecord
  belongs_to :friend, class_name: "User"
  belongs_to :user
  validates :user_id, presence: true, uniqueness: { scope: :friend_id }
  validates :friend_id, presence: true
  validate :friend_request_to_self

  after_create do |f|
    if !Friendship.find_by(user_id: f.friend_id, friend_id: f.user_id)
      Friendship.create!(user_id: f.friend_id, friend_id: f.user_id, confirmation_needed: true)
    end
  end
  after_update do |f|
    reciprocal = Friendship.find_by(user_id: f.friend_id, friend_id: f.user_id)
    reciprocal.update_attributes(confirmed: self.confirmed) unless (reciprocal.nil? or reciprocal.confirmed == self.confirmed)
  end
  after_destroy do |f|
    reciprocal = Friendship.find_by(user_id: f.friend_id, friend_id: f.user_id)
    reciprocal.destroy unless reciprocal.nil?
  end

  private
    def friend_request_to_self
        return errors.add :base, message: 'You cannot send a friend request to your self.' if self.friend_id == self.user_id
    end
end
