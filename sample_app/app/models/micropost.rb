class Micropost < ActiveRecord::Base
  belongs_to :user
  # -> {} の部分はブロック
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
end
