class Micropost < ActiveRecord::Base
  belongs_to :user
  # -> {} の部分はブロック
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  before_save :reply_post

  # 与えられたユーザがフォローしているユーザ達のマイクロポストを返す
  def self.from_users_followed_by(user)
    # followed_user_idsメソッドは、has_many: :followed_usersから自動生成される
    #
    # followed_user_ids = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    # ?を内挿すると自動的に色々補完してくれる
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    # where("user_id IN (:followed_user_ids) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to = :user_id", user_id: user.id)
  end

private

  def reply_post
    # TODO: replyの正規表現一元管理したい
    # TODO: 自動テスト書く
    if /@([a-z]+(_*[a-z]*\d*)*)([[:space:]]|\z)/i =~ self.content
      reply_to_user = User.find_by(name: $1)
      self.in_reply_to = reply_to_user.id unless reply_to_user.nil?
      # unlessに引っかかった時の処理は考慮しているのか
        # Twitterは@user_nameが存在しない場合でも、リプライツイートとしてpostできているのでヨシとする
    end
  end
end
