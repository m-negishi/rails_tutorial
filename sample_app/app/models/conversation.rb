class Conversation < ActiveRecord::Base
  belongs_to :user
  belongs_to :partner, class_name: 'User'
  validates :user_id, presence: true
  validates :partner_id, presence: true

  # def self.feed(user)
  #   # where(in_reply_to: user.id, user_id: user.id)
  #   where("user_id = :user_id OR partner_id = :user_id", user_id: user.id)
  #   # ここで、user_idとin_reply_toの組み合わせをまとめたい
  #   # group('user_id, in_reply_to')
  # end
end
# select * from conversations where user_id = 1 AND partner_id = 2 or user_id = 2 AND partner_id = 1 order by updated_at DESC limit 1;
