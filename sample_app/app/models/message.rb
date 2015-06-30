class Message < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :in_reply_to, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # before_save :reply_post

  def self.reply_to(user)
    # where(in_reply_to: user.id, user_id: user.id)
    where("user_id = :user_id OR in_reply_to = :user_id", user_id: user.id)
  end

  private
  # TODO: micropostと共通メソッドなので要リファクタリング
  # TODO: 今はcontrollerで処理してる(なぜかbefore_saveが動作しない)
  # def reply_post
  #   if /@(.+)[[:space:]]/ =~ self.content
  #     reply_to_user = User.find_by(name: $1)
  #     self.in_reply_to = reply_to_user.id unless reply_to_user.nil?
  #     raise 'reply_test'.inspect
  #     # ユーザが存在しない場合の処理を追加
  #   end
  # end




end
