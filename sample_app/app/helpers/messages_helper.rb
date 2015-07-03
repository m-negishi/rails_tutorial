module MessagesHelper
  def message?(message)
    MESSAGE_PREFIX_REGEX =~ message
  end

  def reply_to?(message)
    VALID_REPLY_USER_REGEX =~ message
  end

end
