class Message < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :in_reply_to, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
