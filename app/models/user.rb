class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true, uniqueness: true
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  def friend(other_user)
    friendships.create!(friend_id: other_user.id)
  end

  def unfriend(other_user)
    friendships.find_by(friend_id: other_user.id).destroy
  end

  def unrelated?(other_user)
    friendships.find_by(friend_id: other_user.id).nil?
  end

  def confirmed_friends
    friendships.where(confirmed: true)
  end

  def confirmed_friend?(other_user)
    !confirmed_friends.find_by(friend_id: other_user.id).nil?
  end

  def pending
    friendships.where(confirmation_needed: false, confirmed: false)
  end

  def pending?(other_user)
    !pending.find_by(friend_id: other_user.id).nil?
  end

  def request
    friendships.where(confirmation_needed: true, confirmed: false)
  end

  def request?(other_user)
    !request.find_by(friend_id: other_user.id).nil?
  end

  def confirm(other_user)
    friendships.find_by(friend_id: other_user.id).update_attributes(confirmed: true)
  end

  def undo_confirm(other_user)
    friendships.find_by(friend_id: other_user.id).update_attributes(confirmed: false)
  end


end
