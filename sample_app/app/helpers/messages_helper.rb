module MessagesHelper
  def message?(message)
    # TODO: 正規表現一元管理したい
    /^d\s/ =~ message
  end

  def reply_to?(message)
    # TODO: 正規表現一元管理したい
    /@(.+)[[:space:]]/ =~ message
  end

end
