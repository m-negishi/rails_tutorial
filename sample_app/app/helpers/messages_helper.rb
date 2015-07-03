module MessagesHelper
  def message?(message)
    # TODO: messageの正規表現一元管理したい
    /^d\s/ =~ message
  end

  def reply_to?(message)
    # TODO: reply機能の正規表現一元管理したい
    /@(\w+)([[:space:]]|\z)/i =~ message
  end

end
