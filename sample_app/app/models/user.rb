class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
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

  private

    def create_remember_token
      # 16桁のランダム文字列を、さらにSHA1で暗号化
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
