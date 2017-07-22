class FriendRequest < ApplicationRecord
  belongs_to :requestor, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :requestor_id, presence: true, uniqueness: { scope: :receiver_id }
  validates :receiver_id, presence: true
  validate :no_friend_request_to_self
  validate :no_reciprocal_friend_request

  private
    def no_friend_request_to_self
        return errors.add :base, message: 'You cannot send a friend request to your self.' if self.requestor_id == self.receiver_id
    end

    def no_reciprocal_friend_request
        if FriendRequest.find_by(requestor_id: self.receiver.id, receiver_id: self.requestor.id)
          return errors.add :base, message: 'You have already been requested to be a friend.'
        end
    end
end
