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

  # classを指定しないと、存在しないReverseRelationshipクラスを探しにいってしまう
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  # 下記はsourceを省略してもよい
  # :followers属性の場合、外部キーは属性を単数形にしたfollower_idを自動で探してくれるため
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save do
    self.email = email.downcase
    # self.name = name.gsub!(/\s/, '_')
  end
  # 上記のように明示的にブロックで渡しているが、以下のようにメソッド参照（メソッドを探す）する方が一般的
  before_create :create_remember_token

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: { case_sensitive: true }#, # trueにした理由
                  #  format: { without: /\s/ } # 全角は？ 元々先頭・末尾のスペースはどういう処理か？
                  #  カラムにユニークキーを追加するかどうか

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
    # 下記でも可能
    # 疑問符があることで、idが確実にエスケープされる
    # Micropost.where("user_id = ?", id)
    # 11章で下記コメントアウト
    # Micropost.where(user_id: id)
    Micropost.from_users_followed_by(self)
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
