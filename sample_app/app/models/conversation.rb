class Conversation < ActiveRecord::Base
  belongs_to :user
  belongs_to :partner, class_name: 'User'
  validates :user_id, presence: true
  validates :partner_id, presence: true
  default_scope -> { order('updated_at DESC') }

  def self.feed(user)
    where("user_id = :user_id OR partner_id = :user_id", user_id: user.id)
  end
end
