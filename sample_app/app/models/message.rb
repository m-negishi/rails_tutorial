class Message < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :in_reply_to, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  before_save :reply_post

  private

    def reply_post
      if /(@)(\w+)/i =~ self.content
        reply_to_user = User.find_by(name: $2)
        self.in_reply_to = reply_to_user.id unless reply_to_user.nil?
      end
    end

    

end
