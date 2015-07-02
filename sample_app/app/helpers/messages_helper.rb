module MessagesHelper
  def message?(message)
    # TODO: 正規表現一元管理したい
    /^d\s/ =~ message
  end

  def reply_to?(message)
    # TODO: 正規表現一元管理したい
    /@([a-z]+(_*[a-z]*\d*)*)([[:space:]]|\z)/i =~ message
  end

end
