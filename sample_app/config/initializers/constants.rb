# TODO: 定数変更するたびにRailsサーバを再起動しないと適用されない…
Rails.application.config.to_prepare do
  VALID_USER_NAME_REGEX = /\A[a-z]\w*/i
  VALID_REPLY_USER_REGEX = /@([a-z]\w*)([[:space:]]|\z)/i
  MESSAGE_PREFIX_REGEX = /^d\s/
end
