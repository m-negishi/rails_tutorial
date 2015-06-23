class Micropost < ActiveRecord::Base
  belongs_to :user
  # -> {} の部分はブロック
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # 与えられたユーザがフォローしているユーザ達のマイクロポストを返す
  def self.from_users_followed_by(user)
    # followed_user_idsメソッドは、has_many: :followed_usersから自動生成される
    #
    # なんでSQLで書きなおすのかわかってない
    # 集合のロジックをDBに保存するから効率がいい？
    # followed_user_ids = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    # ?を内挿すると自動的に色々補完してくれる
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    # where("user_id IN (:followed_user_ids) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to = :user_id", user_id: user.id)
  end
end
