class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # Userモデルオブジェクトの外部キーは、user_idだとRailsは推測する
  # ここではユーザを扱っているが、relationshipsのテーブルのユーザはuser_idではなく、
  # 外部キーであるfollower_idによって特定されるので、明示的に示す
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy

  # has_many :followed_users, through: :relationships
  # このコードはrelationshipsテーブルのfollowed_idを使用して配列を作成する
  # しかし、user.followedsとすると英語としておかしくなるので、user.followed_usersをフォローしているユーザの配列とする
  # followed_users配列の元が、followed id の集合であることを明示するために、sourceで指定する
  has_many :followed_users, through: :relationships, source: :followed

  before_save { self.email = email.downcase }
  # 上記のように明示的にブロックで渡しているが、以下のようにメソッド参照（メソッドを探す）する方が一般的
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password

  def User.new_remember_token
    # 16桁のランダム文字列生成
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    # SHAはBcryptよりも高速（ユーザがアクセスする度に生成されるので重要）
    # tokenがnilのときに扱えるようにto_sを呼び出している（テスト中に発生することがあり得るため）
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # 11章で完全なメソッドになる
    # 下記でも可能
    # 疑問符があることで、idが確実にエスケープされる
    # Micropost.where("user_id = ?", id)
    Micropost.where(user_id: id)
  end

  # あるユーザが別のあるユーザをフォローしているかチェック
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  # あるユーザが別のあるユーザをフォローする（フォロー関係をcreate!する）
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
    # 上記は、下記と同様
    # self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def create_remember_token
      # 16桁のランダム文字列を、さらにSHA1で暗号化
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
