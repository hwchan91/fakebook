class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, :class_name => 'Comment', optional: true
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id'


  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true

  #default_scope -> { order(updated_at: :asc) }

end
