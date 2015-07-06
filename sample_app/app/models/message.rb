class Message < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :in_reply_to, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # before_save :reply_post
  before_save :save_conversation

  def self.reply_to(user, other_user_id)
    where("(user_id = :user_id AND in_reply_to = :other_user_id) OR (user_id = :other_user_id AND in_reply_to = :user_id)", user_id: user.id, other_user_id: other_user_id)
  end

  def self.last_message(user, other_user)
    # where("(user_id = :user_id AND in_reply_to = :other_user_id) OR (user_id = :other_user_id AND in_reply_to = :user_id)", user_id: user.id, other_user_id: other_user.id).first
    # 上記の書き方はrails-style-guideにbadな例として掲載されてる
    # https://github.com/bbatsov/rails-style-guide#find_by
    find_by("(user_id = :user_id AND in_reply_to = :other_user_id) OR (user_id = :other_user_id AND in_reply_to = :user_id)", user_id: user.id, other_user_id: other_user.id)
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

  def save_conversation
    conversation = self.user.conversations.find_by(partner_id: in_reply_to)
    if conversation.nil?
      self.user.conversations.create(partner_id: in_reply_to)
    else
      conversation.update(updated_at: Time.now)
    end
  end

end
