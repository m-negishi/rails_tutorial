class Conversation < ActiveRecord::Base
  belongs_to :user
  belongs_to :partner, class_name: 'User'
  validates :user_id, presence: true
  validates :partner_id, presence: true
  default_scope -> { order('updated_at DESC') }

  def self.feed(user)
    where("user_id = :user_id OR partner_id = :user_id", user_id: user.id).where.not(["user_id = ? and partner_id = ?", user.id, user.id])
    # TODO: 自分自身へのメッセージは入れられないようにフォームでバリデーションかける
    # TODO: FactoryGirlも自分にはメッセージ送れないようにする？
    # TODO: このままだと、1to2の会話と2to1の会話が別物として取得されてしまう
  end
end
