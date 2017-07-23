class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }
  validates :user, presence: true
  validates :content, presence: true
end
