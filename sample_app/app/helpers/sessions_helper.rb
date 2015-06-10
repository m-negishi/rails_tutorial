module SessionsHelper

  def sign_in(user)
    # トークン生成
    remember_token = User.new_remember_token
    # 暗号化していないトークンをクッキーに保存
    # permanentメソッドで自動的にcookieは20年後に切れるようになる
    cookies.permanent[:remember_token] = remember_token
    # 暗号化したトークンをDBに保存
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # 与えられたuserを現在のユーザに設定
    # selfがないとcurrent_userというローカル変数が生成される
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  # 以下は、attr_accessorでは代用できない
  # ユーザが別のページに遷移すると、セッションが終了してしまう
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    # ||= : or eauals(左辺が偽か未定義なら右辺を代入、初期化)
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    # 現在のuser情報をnil
    self.current_user = nil
    # cookieも削除
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    # session[:return_to]がnilならdefaultを代入
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  # UserControllerより移植
  # MicropostControllerでも使いたいため
  def signed_in_user
    unless signed_in?
      # 遷移しようとしていたurlを保持(SessionsHelper)
      store_location
      redirect_to signin_url, notice: 'Please sign in.'
    end
  end
end
