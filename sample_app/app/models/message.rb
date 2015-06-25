class Message < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :in_reply_to, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
